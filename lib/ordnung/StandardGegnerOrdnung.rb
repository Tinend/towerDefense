require 'GegnerOrdnung'

class StandardGegnerOrdnung < GegnerOrdnung
  def <=>(ordnung)
    @gegner.laufDistanz <=> ordnung.gegner.laufDistanz
  end
end
