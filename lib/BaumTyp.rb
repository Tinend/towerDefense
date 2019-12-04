require 'Baum'

class BaumTyp
  def initialize(reichweite, staerke)
    @reichweite = reichweite
    @staerke = staerke
  end

  attr_reader :reichweite, :staerke
  
  def erstelleBaum(staerke)
    Baum.new(@reichweite, @staerke * staerke / 100)
  end
end
