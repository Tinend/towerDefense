Schwarz = 0
Blau = 1
Cyan = 2
Gruen = 3
Magenta = 4
Rot = 5
Weiss = 6
Gelb = 7
#CyanSchwarz = 120
#CyanGruen = 123
#CyanWeiss = 126
#GruenSchwarz = 130
#MagentaSchwarz = 140
#RotSchwarz = 150
#RotBlau = 151
#RotCyan = 152
#RotRot = 155
#RotWeiss = 156
#WeissBlau = 161
#WeissGruen = 163
#GelbSchwarz = 170
#GelbGruen = 173
#GelbWeiss = 176
def farben()
  colors = [COLOR_BLACK, COLOR_BLUE, COLOR_CYAN, COLOR_GREEN, COLOR_MAGENTA, COLOR_RED, COLOR_WHITE, COLOR_YELLOW]
  8.times do |vordergrund|
    8.times do |hintergrund|
      Curses.init_pair(berechneFarbe(vordergrund, hintergrund), colors[vordergrund], colors[hintergrund])
    end
  end
  #Curses.init_pair(CyanSchwarz, COLOR_CYAN, COLOR_BLACK)
  #Curses.init_pair(CyanGruen, COLOR_CYAN, COLOR_GREEN)
  #Curses.init_pair(CyanWeiss, COLOR_CYAN, COLOR_WHITE)
  #Curses.init_pair(GruenSchwarz, COLOR_GREEN, COLOR_BLACK)
  #Curses.init_pair(MagentaSchwarz, COLOR_MAGENTA, COLOR_BLACK)
  #Curses.init_pair(RotSchwarz, COLOR_RED, COLOR_BLACK)
  #Curses.init_pair(RotBlau, COLOR_RED, COLOR_BLUE)
  #Curses.init_pair(RotCyan, COLOR_RED, COLOR_CYAN)
  #Curses.init_pair(RotRot, COLOR_RED, COLOR_RED)
  #Curses.init_pair(RotWeiss, COLOR_RED, COLOR_WHITE)
  #Curses.init_pair(WeissBlau, COLOR_WHITE, COLOR_BLUE)
  #Curses.init_pair(WeissGruen, COLOR_WHITE, COLOR_GREEN)
  #Curses.init_pair(GelbSchwarz, COLOR_YELLOW, COLOR_BLACK)
  #Curses.init_pair(GelbGruen, COLOR_YELLOW, COLOR_GREEN)
  #Curses.init_pair(GelbWeiss, COLOR_YELLOW, COLOR_WHITE)
end

def berechneFarbe(vordergrund, hintergrund)
  100 + 10 * vordergrund + hintergrund
end
#:COLOR_BLACK, :COLOR_BLUE, :COLOR_CYAN, :COLOR_GREEN, :COLOR_MAGENTA, :COLOR_RED, :COLOR_WHITE, :COLOR_YELLOW
#  0                 1           2                 3            4            5             6           7
