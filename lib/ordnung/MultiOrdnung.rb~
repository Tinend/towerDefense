require 'GegnerOrdnung'

class MultiOrdnung
  def initialize(gegner)
    @gegner = [gegner]
  end

  attr_reader :gegner
  
  def <=>(multiOrdnung)
    @gegner[0].laufDistanz <=> multiOrdnung.gegner[0].laufDistanz
  end

  def +(multiOrdnung)
    @gegner += multiOrdnung.gegner
  end

  def zusammenfuegbar(multiOrdnung)
    @gegner[0].position == multiOrdnung.gegner[0].position
  end
end
