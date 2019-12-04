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
    Baum.new(REICHWEITE, position)
  end

  def reichweite()
    REICHWEITE
  end

end
