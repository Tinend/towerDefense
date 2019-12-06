require 'GegnerArray'

class GegnerErsteller
  Typen = [:wasser, :pflanze, :feuer]
  
  def initialize(start)
    @start = start
    @anzahl = 1
    @faktor = 1
    @runde = 0
    @staerkePolynom = [1, 1, -1]
    @typ = rand(3)
    @staerke = 1
    @geschwindigkeit = 1
  end

  attr_accessor :staerkePolynom
  attr_reader :anzahl, :staerke, :geschwindigkeit

  def typ()
    Typen[@typ % 3]
  end
  
  def definiereGegner()
    @runde += 1
    if typ() == :feuer
      feuerErstellen()
    elsif typ() == :pflanze
      pflanzeErstellen()
    elsif typ() == :wasser
      wasserErstellen()
    end
  end
  
  def erstelleGegner()
    @array = GegnerArray.new(@start, @anzahl, @staerke, typ(), @geschwindigkeit)
    @typ += 1
    @array
  end

  def gesamtLp()
    staerke = @staerkePolynom.reduce(0) {|wert, koeffizient| wert * @runde + koeffizient}
    staerke * @anzahl
  end

  def feuerErstellen()
    @staerke = @staerkePolynom.reduce(0) {|wert, koeffizient| wert * @runde + koeffizient}
    @anzahl = 1
    until rand(4) == 0
      @anzahl += 1
    end
    @geschwindigkeit = rand(0) * 3 + 1
    @staerke *= 1.5 + 2.0 / @geschwindigkeit / @anzahl
    @staerke = @staerke.to_i
  end

  def wasserErstellen()
    @staerke = @staerkePolynom.reduce(0) {|wert, koeffizient| wert * @runde + koeffizient}
    @anzahl = 1
    until rand(10) == 0
      @anzahl += 1
    end
    @geschwindigkeit = rand(0) + 1
    @staerke *= 1 + 1.4 / @geschwindigkeit / @anzahl
    @staerke = @staerke.to_i
  end
  
  def pflanzeErstellen()
    @staerke = @staerkePolynom.reduce(0) {|wert, koeffizient| wert * @runde + koeffizient}
    @anzahl = 1
    until rand(3) == 0
      @anzahl += 1
    end
    @geschwindigkeit = rand(0) + 0.5
    @staerke *= 1.5 + 2.0 / @geschwindigkeit / @anzahl
    @staerke = @staerke.to_i
  end
end
