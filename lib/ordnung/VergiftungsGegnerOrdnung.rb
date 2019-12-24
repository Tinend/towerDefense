require 'GegnerOrdnung'

class VergiftungsGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.leben < 0
      return -1
    elsif ordnung.gegner.leben < 0
      return 1
    elsif @gegner.vergiftungsCounter != ordnung.gegner.vergiftungsCounter
      return - (@gegner.vergiftungsCounter <=> ordnung.gegner.vergiftungsCounter)
    end
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
