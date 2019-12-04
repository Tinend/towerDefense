class GegnerOrdnung
  def initialize(gegner)
    @gegner = gegner
  end

  attr_reader :gegner
  
  def <=>(ordnung)
    1
  end
end
