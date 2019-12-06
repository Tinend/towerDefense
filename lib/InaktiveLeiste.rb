require 'ordnung/StandardGegnerOrdnung'
require 'farben'

class InaktiveLeiste
  def initialize(hoehe, breite, spieler)
    @hoehe = hoehe
    @breite = breite
    @spieler = spieler
  end

  def oeffnen()
    @window = Window.new(@hoehe, @breite, 0, 0)
  end

  def lebenAnzeigen(verschiebung)
    herz = @spieler.herz()
    herz.each_with_index do |zeile, y|
      zeile.length.times do |x|
        @window.setpos(y, x + verschiebung)
        if zeile[x] == "#"
          @window.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
            @window.addstr(" ")
          }
        elsif zeile[x] != " "
          @window.attron(color_pair(berechneFarbe(Gelb, Rot))|A_NORMAL) {
            @window.addstr(zeile[x])
          }
        end
      end
    end
  end

  def gegnerLebenAnzeigen(verschiebung)
    return if @gegnerArray == nil
    4.times do |y|
      @window.setpos(y, verschiebung)
      @window.addstr(" " * 120)
    end
    gegnerOrdnungen = @gegnerArray.gegner.map {|gegner| StandardGegnerOrdnung.new(gegner)}
    gegnerOrdnungen.sort!.reverse!
    gegnerOrdnungen[0..23].each_with_index do |gegnerOrdnung, index|
      gegner = gegnerOrdnung.gegner
      x = index
      x /= 4
      x *= 20
      y = index % 4      
      @window.setpos(y, x + verschiebung)
      @window.addstr("[")
      next if gegner.leben <= 0
      lpFarbe = berechneLpFarbe(gegner)
      lpLaenge = (gegner.leben * 10.0 / gegner.maxLeben + 0.5).to_i
      @window.attron(color_pair(berechneFarbe(lpFarbe, Schwarz))|A_NORMAL) {
        @window.addstr("=" * lpLaenge + " " * (10 - lpLaenge))
      }
      @window.addstr("]")
      zeichen = 0
      if gegner.versteinert?()
        @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
          @window.addstr("=")
        }
        zeichen += 1
      end
      if gegner.krank > 0
        @window.attron(color_pair(berechneFarbe(Schwarz, Weiss))|A_NORMAL) {
          @window.addstr("!")
        }
        zeichen += 1
      end
      if gegner.vereisungsCounter > 0
        @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
          @window.addstr("*")
        }
        zeichen += 1
      end
      if gegner.vergiftungsCounter > 0
        @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
          @window.addstr(":")
        }
        zeichen += 1
      end
      if gegner.verlangsamungsCounter > 0
        @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
          @window.addstr("#")
        }
        zeichen += 1
      end
      @window.addstr(" " * (10 - zeichen))
      @window.refresh()
    end
  end
  
  def anzeigen()
    lebenAnzeigen(2)
    gegnerLebenAnzeigen(11)
  end
  
  def berechneLpFarbe(gegner)
    if gegner.leben == gegner.maxLeben
      return Cyan
    elsif gegner.leben / gegner.maxLeben.to_f > 0.75
      return Gruen
    elsif gegner.leben / gegner.maxLeben.to_f > 0.5
      return Gelb
    elsif gegner.leben / gegner.maxLeben.to_f > 0.25
      return Rot
    else
      return Magenta
    end
  end
    
  def schliessen
    @window.close()
  end

  def anschalten(gegnerArray)
    @gegnerArray = gegnerArray
  end
end
