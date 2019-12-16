require 'GegnerOrdnung'

class HeilungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.leben != ordnung.gegner.leben
      return - (@gegner.leben <=> ordnung.gegner.leben)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
