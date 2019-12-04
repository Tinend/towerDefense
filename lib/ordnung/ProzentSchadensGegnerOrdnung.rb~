require 'GegnerOrdnung'

class KrankheitssGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.krank != ordnung.gegner.krank
      return @gegner.krank <=> ordnung.gegner.krank
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
