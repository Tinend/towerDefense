require 'BaumUpgradeFenster'

class BaumUpgradeFenster
  Wahlen = [:nichts, :feuer, :pflanze, :wasser]
  
  def initialize(hoehe, breite, verschiebungy, verschiebungx, elternFenster)
    @hoehe = hoehe
    @breite = breite
    @elternFenster = elternFenster
    @verschiebungy = verschiebungy
    @verschiebungx = verschiebungx
    @fensterBreite = 45
    @fensterHoehe = 15
    @wahl = 0
  end

  def erneuern()
    @elternFenster.erneuern()
    anzeigen()
  end

  def anzeigen()
    @fenster.setpos(0,0)
    @fenster.addstr("/" + "-" * (@fensterBreite - 2) + "\\")
    @fenster.setpos(2, 12)
    @fenster.addstr("Schussrate:      " + @baum.maxLaden().to_s)
    @fenster.addstr("   ")
    @fenster.setpos(3, 12)
    @fenster.addstr("Reichweite:      " + @baum.reichweite().to_s)
    @fenster.addstr("   ")
    @fenster.setpos(4, 12)
    @fenster.addstr("Schaden Feuer:   ")
    @fenster.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL){
      @fenster.addstr(@baum.berechneSchaden(:feuer).to_s)
    }
    @fenster.addstr("   ")
    @fenster.setpos(5, 12)
    @fenster.addstr("Schaden Pflanze: ")
    @fenster.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL){
      @fenster.addstr(@baum.berechneSchaden(:pflanze).to_s)
    }
    @fenster.addstr("   ")
    @fenster.setpos(6, 12)
    @fenster.addstr("Schaden Wasser:  ")
    @fenster.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL){
      @fenster.addstr(@baum.berechneSchaden(:wasser).to_s)
    }
    @fenster.addstr("   ")
    @fenster.setpos(8,16)
    @fenster.addstr("+--+--+--+--+")
    @fenster.setpos(9,16)
    @fenster.addstr("|  |  |  |  |")
    @fenster.setpos(10,16)
    @fenster.addstr("+--+--+--+--+")
    4.times do |i|
      @fenster.setpos(9, 17 + 3 * i)
      farbe = berechneFarbe(Gelb, @baum.upgradeFarbe(i))
      @fenster.attron(color_pair(farbe)|A_NORMAL){
        @fenster.addstr("  ")
      }
    end
    y = 12
    @baum.sonderfaehigkeiten.each_with_index do |sf, index|
      x = 5 - index
      zeigeKombination(x, y, @baum.sonderfaehigkeiten()[index].bedingung)
      sf.beschreibung(@fensterBreite - 8).each do |zeile|
        @fenster.setpos(y, 6)
        @fenster.addstr(zeile)
        @fenster.addstr(" " * (@fensterBreite - 8 - zeile.length))
        y += 1
      end
      @fenster.setpos(y, 1)
      @fenster.addstr(" " * (@fensterBreite - 2))
      y += 1
    end
    [6, @fensterHoehe - y - 2].min.times do
      @fenster.setpos(y, 1)
      @fenster.addstr(" " * (@fensterBreite - 2))
      y += 1
    end
    (@fensterHoehe - 2).times do |y|
      @fenster.setpos(y + 1, 0)
      @fenster.addstr("|")
      @fenster.setpos(y + 1, @fensterBreite - 1)
      @fenster.addstr("|")
    end
    @fenster.setpos(@fensterHoehe - 1, 0)
    @fenster.addstr("\\" + "-" * (@fensterBreite - 2) + "/")
    @fenster.setpos(0,0)
  end

  def zeigeKombination(x, y, kombination)
    @fenster.setpos(y, x)
    kombination.each do |k|
      if k == :pflanze
        @fenster.attron(color_pair(berechneFarbe(Gruen, Gruen))|A_NORMAL) {
          @fenster.addstr(" ")
        }
      elsif k == :feuer
        @fenster.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
          @fenster.addstr(" ")
        }
      elsif k == :wasser
        @fenster.attron(color_pair(berechneFarbe(Blau, Blau))|A_NORMAL) {
          @fenster.addstr(" ")
        }
      end
    end
  end
  
  def oeffnen(baum)
    @baum = baum
    @fensterHoehe = 18 + 4 * @baum.sonderfaehigkeiten().length
    @wahl = 0
    @fenster = Window.new(@fensterHoehe, @fensterBreite, @verschiebungy + @hoehe / 2 - @fensterHoehe / 2, @verschiebungx + @breite / 2 - @fensterBreite / 2)
    @fenster.keypad = true
    erneuern()
  end

  def schliessen()
    @fenster.close()
    @elternFenster.erneuern()
  end

  def auswaehlen()
    m = 0
    until m == KEY_ENTER_REAL
      m = @fenster.getch
      if m == KEY_UP
        @baum.downgraden() unless Wahlen[@wahl] == :nichts
        @wahl -= 1
        @wahl %= Wahlen.length #=
        @baum.upgraden(Wahlen[@wahl]) unless Wahlen[@wahl] == :nichts
        anzeigen()
      elsif m == KEY_DOWN
        @baum.downgraden() unless Wahlen[@wahl] == :nichts
        @wahl += 1
        @wahl %= Wahlen.length #=
        @baum.upgraden(Wahlen[@wahl]) unless Wahlen[@wahl] == :nichts
        anzeigen()
      end
    end
    Wahlen[@wahl]
  end
end
