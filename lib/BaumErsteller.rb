require 'Baum'

class BaumErsteller
  ANFANGSSTAERKE = 1
  REICHWEITE = 1.5
  def initialize()
    @grundStaerke = ANFANGSSTAERKE
    @aktiv = true
  end

  attr_accessor :aktiv, :grundStaerke
  attr_reader :staerke

  def schaden()
    @grundStaerke
  end
    
  def erstelleBaum(position)
    baum = Baum.new(REICHWEITE, position)
    Siegesbedingungen.each do |s|
      s.pflanze(baum)
    end
    baum
  end

  def reichweite()
    REICHWEITE
  end

end
