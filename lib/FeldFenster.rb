include Curses
require 'colorize'
require 'Baum'
require 'Sonderfaehigkeit'

class FeldFenster  
  def initialize(verschiebungy, verschiebungx, spielfeld, baumErsteller, menues, leiste, spieler)
    @spieler = spieler
    @hoehe = spielfeld.hoehe
    @breite = spielfeld.breite
    @verschiebungy = verschiebungy
    @verschiebungx = verschiebungx
    @baumErsteller = baumErsteller
    @spielfeld = spielfeld
    @menues = menues
    @leiste = leiste
    @position = [0, 0]
    @spielerAktiv = false
    @karte = Window.new(@hoehe * HOEHENFAKTOR, @breite * BREITENFAKTOR, @verschiebungy, @verschiebungx)
    @karte.keypad = true
    @baumLevel = [0, 0, 0, 0, 0]
  end

  def erneuern()
    anzeigen()
  end

  def kurzAnzeigen()
    @leiste.inaktivAnzeigen()
    @hoehe.times do |y|
      @breite.times do |x|
        male(x,y) if @spielfeld.istWeg?(x, y)
      end
    end
    @karte.refresh()    
  end
  
  def anzeigen()
    if @spielerAktiv
      if @spielfeld.hatBaum?(@position[0], @position[1])
        baum = @spielfeld.gibBaum(@position[0], @position[1])
        @leiste.bauPhaseAnfangen()
      else
        @leiste.bauPhaseBeenden(@spielfeld.gibFeuer(@position[0], @position[1]))
        baum = nil
      end
      @leiste.aktivAnzeigen(baum)
    end
    @hoehe.times do |y|
      @breite.times do |x|
        male(x,y)
      end
    end
    @karte.refresh()
  end

  def male(x,y)
    BREITENFAKTOR.times do |xKlein|
      HOEHENFAKTOR.times do |yKlein|
        @karte.setpos(y * HOEHENFAKTOR + yKlein, x * BREITENFAKTOR + xKlein)
        farbe = findeFarbe(x, y, xKlein, yKlein)
        string = findeZeichen(x, y, xKlein, yKlein)
        @karte.attron(color_pair(farbe)|A_NORMAL){
          @karte.addstr(string)
        }
      end
    end
  end
  
  def berechneTreffer()
    @spielfeld.berechneTreffer(@position, @baumErsteller.reichweite())
  end

  def findeFarbe(x, y, xKlein, yKlein)
    100 + 10 * findeVordergrundFarbe(x, y, xKlein, yKlein) + findeHintergrundFarbe(x, y, xKlein, yKlein)
  end
  
  def findeVordergrundFarbe(x, y, xKlein, yKlein)
    return Rot if (xKlein == 1 or xKlein == 3) and (yKlein == 0 or yKlein == 2) and x == @position[0] and y == @position[1] and @spielerAktiv
    return @spielfeld.feindBild(x, y, xKlein, yKlein).vordergrundFarbe if @spielfeld.istWeg?(x,y) and @spielfeld.hatFeind?(x,y)
    return @spielfeld.feldFarbe(x, y) if @spielfeld.istWeg?(x, y)
    if @spielfeld.hatBaum?(x, y)
      return @spielfeld.baumVordergrundFarbe(x, y, xKlein, yKlein)
    end
    return Gelb
  end
  
  def findeHintergrundFarbe(x, y, xKlein, yKlein)
    farbe = Cyan
    farbe = Weiss if nah?(x, y) and @spielerAktiv
    if @spielfeld.hatBaum?(x, y)
      return @spielfeld.baumHintergrundFarbe(x, y, xKlein, yKlein, farbe)
    end
    return Magenta if @spielfeld.istWeg?(x, y) and nah?(x, y) and @spielerAktiv
    return @spielfeld.feindBild(x, y, xKlein, yKlein).hintergrundFarbe if @spielfeld.istWeg?(x,y) and @spielfeld.hatFeind?(x,y)
    return Blau if @spielfeld.istWeg?(x, y)
    return farbe
  end
  
  def findeZeichen(x, y, xKlein, yKlein)
    return "\\" if ((xKlein == 1 and yKlein == 0) or (xKlein == 3 and yKlein == 2)) and x == @position[0] and y == @position[1] and @spielerAktiv
    return "/" if ((xKlein == 1 and yKlein == 2) or (xKlein == 3 and yKlein == 0)) and x == @position[0] and y == @position[1] and @spielerAktiv
    return @spielfeld.feindBild(x, y, xKlein, yKlein).zeichen if @spielfeld.istWeg?(x,y) and @spielfeld.hatFeind?(x,y)
    return "~" if xKlein == 2 and yKlein == 1 and @spielfeld.istWeg?(x, y)
    if @spielfeld.hatBaum?(x, y)
      return @spielfeld.baumZeichen(x, y, xKlein, yKlein)
    end
    return "+" if (xKlein == 0 or xKlein == 4) and (yKlein == 0 or yKlein == 2) and not @spielfeld.istWeg?(x, y)
    return " "
  end
  
  def nah?(x, y)
    if @spielfeld.hatBaum?(@position[0], @position[1])
      reichweite = @spielfeld.gibBaum(@position[0], @position[1]).reichweite()
    elsif @spielfeld.istWeg?(@position[0], @position[1]) or not @spielfeld.hatBaum?(@position[0], @position[1])
      reichweite = @baumErsteller.reichweite
    else
      raise
      return false
    end
    ((x - @position[0]) ** 2 + (y - @position[1]) ** 2 <= reichweite ** 2)
  end
  
  def oeffnen()
    anzeigen()
  end

  def schliessen()
    @karte.close()
  end

  def positionBaubar?()
    positionLegal and not @spielfeld.hatBaum?(@position[0], @position[1]) and @spieler.kannTurmBauen?()
  end
  
  def positionErweiterbar?()
    return false unless @spielfeld.hatBaum?(@position[0], @position[1])
    baum = @spielfeld.gibBaum(@position[0], @position[1])
    return false if baum.level == 4
    #return false if @baumLevel[baum.level + 1] + 2 > @baumLevel[baum.level]
    true
  end
  
  def positionLegal()
    not @spielfeld.istWeg?(@position[0], @position[1])
  end

  def baumBauPhase()
    @baumErsteller.aktiv = true
    @leiste.bauPhaseAnfangen()
    anzeigen()
    loop do
      eingabe = eingeben()
      if eingabe == :bauen and positionBaubar?()
        @spielfeld.pflanzeBaum(@position, @baumErsteller.erstelleBaum(@position.dup))
        @spieler.turmBezahlen()
        @baumLevel[0] += 1
      elsif eingabe == :bauen and positionErweiterbar?()
        baum = @spielfeld.gibBaum(@position[0], @position[1])
        if @spieler.turmUpgradebar?(baum.level + 1)
          wahl = @menues[:baumUpgradeFensterBuilder].waehlen(baum)
          if wahl != :nichts
            @spieler.upgradeBezahlen(baum.level)
            @spieler.leben += Sonderfaehigkeit::BonusLeben if baum.hatUpgrade?(HeilungsSonderfaehigkeit.bedingung)
            @baumLevel[baum.level - 1] -= 1
            @baumLevel[baum.level] += 1
          end
        end
      elsif eingabe == :fertig
        bauPhaseBeenden()
        return 0
      end
      anzeigen()
    end
  end

  def bauPhaseBeenden()
    @spielerAktiv = false
    anzeigen()
  end

  def baumErweiterPhase()
    @baumErsteller.aktiv = false
    anzeigen()
    loop do
      eingabe = eingeben()
      if eingabe == :bauen and positionErweiterbar?()
        baum = @spielfeld.gibBaum(@position[0], @position[1])
        wahl = @menues[:baumUpgradeFensterBuilder].waehlen(baum)
        if wahl != :nichts
          @spieler.leben += Sonderfaehigkeit::BonusLeben if baum.hatUpgrade?(HeilungsSonderfaehigkeit.bedingung)
          @baumLevel[baum.level - 1] -= 1
          @baumLevel[baum.level] += 1
          @spielerAktiv = false
          anzeigen()
          return 0
        end
      end
      anzeigen()
    end
  end

  def eingeben()
    m = @karte.getch
      if m == KEY_SUP
      @position[1] -= 7
      @position[1] %= @hoehe
    elsif m == KEY_SDOWN
      @position[1] += 7
      @position[1] %= @hoehe
    elsif m == KEY_SRIGHT
      @position[0] += 7
      @position[0] %= @breite
    elsif m == KEY_SLEFT
      @position[0] -= 7
      @position[0] %= @breite
    elsif m == KEY_UP
      @position[1] -= 1
      @position[1] %= @hoehe
    elsif m == KEY_DOWN
      @position[1] += 1
      @position[1] %= @hoehe
    elsif m == KEY_RIGHT
      @position[0] += 1
      @position[0] %= @breite
    elsif m == KEY_LEFT
      @position[0] -= 1
      @position[0] %= @breite
    elsif m == KEY_ENTER_REAL
      return :bauen
    elsif m == KEY_SLEERZEICHEN
      return :fertig
    elsif m == " "
      begin
        @menues[:nutzenAnzeiger].oeffnen()
        @menues[:nutzenAnzeiger].auswaehlen()
        @menues[:nutzenAnzeiger].anzeigen()
      ensure
        @menues[:nutzenAnzeiger].schliessen()
      end
    end
    return nil
  end

  def anfangsPhase()
    begin
      @spielerAktiv = true
      @leiste.aktivieren(@baumLevel)
      erneuern()
      baumBauPhase()
      baumBauPhase()
    ensure
      @leiste.deaktivieren()
    end
  end
  
  def aktivePhase()
    begin
      @spielerAktiv = true
      @leiste.aktivieren(@baumLevel)
      erneuern()
      baumBauPhase()
      #baumErweiterPhase()
    ensure
      @leiste.deaktivieren()
    end
  end
end
