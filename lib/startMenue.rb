include Curses
require 'colorize'

def startMenueAnzeigen(menue, farben)
  menue.setpos(0,0)
  menue.addstr("/------------------\\")
  menue.setpos(1,0)
  menue.addstr("|")
  menue.attron(color_pair(farben[0])|A_NORMAL){
    menue.addstr("     Einfach      ")
  }
  menue.addstr("|")
  menue.setpos(2,0)
  menue.addstr("|")
  menue.attron(color_pair(farben[1])|A_NORMAL){
    menue.addstr("      Mittel      ")
  }
  menue.addstr("|")
  menue.setpos(3,0)
  menue.addstr("|")
  menue.attron(color_pair(farben[2])|A_NORMAL){
    menue.addstr("    Schwierig     ")
  }
  menue.addstr("|")
  menue.setpos(4,0)
  menue.addstr("\\------------------/")
  menue.refresh()
end

def startMenue(hoehe, breite)
  begin
    menue = Window.new(5, 20, Freiraum + hoehe / 2 - 2, breite / 2 - 10)
    menue.keypad = true
    farbenMenue = [findeFarbe(Schwarz, Weiss), findeFarbe(Weiss, Schwarz), findeFarbe(Weiss, Schwarz)]
    startMenueAnzeigen(menue, farbenMenue)
    position = 0
    m = 0
    until m == KEY_ENTER_REAL
      m = menue.getch
      if m == KEY_UP
        farbenMenue[position] = findeFarbe(Weiss, Schwarz)
        position = [0, position - 1].max
        farbenMenue[position] = findeFarbe(Schwarz, Weiss)
        startMenueAnzeigen(menue, farben)
      elsif m == KEY_DOWN
        farbenMenue[position] = findeFarbe(Weiss, Schwarz)
        position = [2, position + 1].min
        farbenMenue[position] = findeFarbe(Schwarz, Weiss)
        startMenueAnzeigen(menue, farben)
      end
    end
    return position
  ensure
    menue.close()
  end
end
