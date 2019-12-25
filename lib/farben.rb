Schwarz = 0
Blau = 1
Cyan = 2
Gruen = 3
Magenta = 4
Rot = 5
Weiss = 6
Gelb = 7
def farben()
  colors = [COLOR_BLACK, COLOR_BLUE, COLOR_CYAN, COLOR_GREEN, COLOR_MAGENTA, COLOR_RED, COLOR_WHITE, COLOR_YELLOW]
  8.times do |vordergrund|
    8.times do |hintergrund|
      Curses.init_pair(berechneFarbe(vordergrund, hintergrund), colors[vordergrund], colors[hintergrund])
    end
  end
end

def berechneFarbe(vordergrund, hintergrund)
  100 + 10 * vordergrund + hintergrund
end
#:COLOR_BLACK, :COLOR_BLUE, :COLOR_CYAN, :COLOR_GREEN, :COLOR_MAGENTA, :COLOR_RED, :COLOR_WHITE, :COLOR_YELLOW
#  0                 1           2                 3            4            5             6           7
