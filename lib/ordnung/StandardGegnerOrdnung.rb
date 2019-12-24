require 'GegnerOrdnung'

class StandardGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    if @gegner.leben < 0
      return -1 
    elsif ordnung.gegner.leben < 0
      return 1 
    else
      return @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
    end
  end
end
