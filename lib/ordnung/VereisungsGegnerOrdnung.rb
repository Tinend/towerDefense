require 'GegnerOrdnung'

class VereisungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.leben < 0
      return -1
    elsif ordnung.gegner.leben < 0
      return 1
    elsif @gegner.vereisungsCounter != ordnung.gegner.vereisungsCounter
      return - (@gegner.vereisungsCounter <=> ordnung.gegner.vereisungsCounter)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
