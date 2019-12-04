require 'GegnerOrdnung'

class KrankheitsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.krank != ordnung.gegner.krank
      return @gegner.krank <=> ordnung.gegner.krank
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
