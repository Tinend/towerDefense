require 'GegnerOrdnung'

class VereisungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.vereisungsCounter != ordnung.gegner.vereisungsCounter
      return - (@gegner.vereisungsCounter <=> ordnung.gegner.vereisungsCounter)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
