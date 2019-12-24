require 'GegnerOrdnung'

class HeilungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.leben < 0
      return -1
    elsif ordnung.gegner.leben < 0
      return 1
    elsif @gegner.leben != ordnung.gegner.leben
      return - (@gegner.leben <=> ordnung.gegner.leben)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
