require 'GegnerOrdnung'

class VerlangsamungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.verlangsamungsCounter != ordnung.gegner.verlangsamungsCounter
      return @gegner.verlangsamungsCounter <=> ordnung.gegner.verlangsamungsCounter
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
