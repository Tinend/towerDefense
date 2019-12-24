require 'GegnerOrdnung'

class VerlangsamungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.leben < 0
      return -1
    elsif ordnung.gegner.leben < 0
      return 1
    elsif @gegner.verlangsamungsCounter != ordnung.gegner.verlangsamungsCounter
      return - (@gegner.verlangsamungsCounter <=> ordnung.gegner.verlangsamungsCounter)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
