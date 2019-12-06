require 'GegnerOrdnung'

class VergiftungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.vergiftungsCounter != ordnung.gegner.vergiftungsCounter
      return - (@gegner.vergiftungsCounter <=> ordnung.gegner.vergiftungsCounter)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
