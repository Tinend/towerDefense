require 'GegnerOrdnung'

class KrankheitsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.leben < 0
      return -1
    elsif ordnung.gegner.leben < 0
      return 1
    elsif @gegner.krank != ordnung.gegner.krank
      return - (@gegner.krank <=> ordnung.gegner.krank)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
