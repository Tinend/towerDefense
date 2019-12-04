include Curses
require 'colorize'

class Menue
  MenueFarbeWeiss = 100
  MenueFarbeSchwarz = 101
  def initialize(auswahlMoeglichkeiten, hoehe, breite, verschiebungy, verschiebungx, elternFenster)
    @auswahlMoeglichkeiten = auswahlMoeglichkeiten.dup
    @hoehe = hoehe
    @breite = breite
    @elternFenster = elternFenster
    @verschiebungy = verschiebungy
    @verschiebungx = verschiebungx
    @menueBreite = 4
    @auswahlMoeglichkeiten.each do |wahl|
      @menueBreite = [@menueBreite, 4 + wahl.length].max
    end
    @menueHoehe = @auswahlMoeglichkeiten.length + 2
    @wahl = 0
    Curses.init_pair(MenueFarbeSchwarz, COLOR_BLACK, COLOR_WHITE)
    Curses.init_pair(MenueFarbeWeiss, COLOR_WHITE, COLOR_BLACK)
  end

  def erneuern()
    @elternFenster.erneuern()
    anzeigen()
  end

  def anzeigen()
    @menue.setpos(0,0)
    @menue.addstr("/" + "-" * (@menueBreite - 2) + "\\")
    @auswahlMoeglichkeiten.each_with_index do |wahl, index|
      @menue.addstr("|")
      if index == @wahl
        farbe = MenueFarbeSchwarz
      else
        farbe = MenueFarbeWeiss
      end
      string = " " * ((@menueBreite - wahl.length - 2) / 2)
      string += wahl
      string += " " * ((@menueBreite - wahl.length - 1) / 2)
      @menue.attron(color_pair(farbe)|A_NORMAL){
        @menue.addstr(string)
      }
      @menue.addstr("|")
    end
    @menue.addstr("\\" + "-" * (@menueBreite - 2) + "/")
  end
  
  def oeffnen()
    @wahl = 0
    @menue = Window.new(@menueHoehe, @menueBreite, @verschiebungy + @hoehe / 2 - @menueHoehe / 2, @verschiebungx + @breite / 2 - @menueBreite / 2)
    @menue.keypad = true
    erneuern()
  end

  def schliessen()
    @menue.close()
    @elternFenster.erneuern()
  end

  def auswaehlen()
    m = 0
    until m == KEY_ENTER_REAL
      m = @menue.getch
      if m == KEY_UP
        @wahl = [0, @wahl - 1].max
        anzeigen()
      elsif m == KEY_DOWN
        @wahl = [@menueHoehe - 3, @wahl + 1].min
        anzeigen()
      end
    end
    @auswahlMoeglichkeiten[@wahl]
  end
end
