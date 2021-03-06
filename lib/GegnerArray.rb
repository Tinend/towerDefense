require 'Feind'
require 'WegStueck'
require 'Gegner'

class GegnerArray
  GegnerAbstand = 10
  def initialize(start, gegnerZahl, maxLp, typ, geschwindigkeit, spieler)
    @typ = typ
    @maxLp = maxLp
    @rein = 0
    @gegnerZahl = gegnerZahl
    @geschwindigkeit = geschwindigkeit
    @start = start
    @gegner = []
    @runde = 0
    @spieler = spieler
  end

  attr_reader :gegner
  
  def leben()
    Array.new(@gegner.length) {|i|
      Gegner.new(@gegner.lp, @maxLp)
    }
  end

  def bewegen()
    if @runde % GegnerAbstand == 0 and @rein < @gegnerZahl
      @rein += 1
      @gegner.push(Feind.new(@maxLp, @start, @typ, @geschwindigkeit))
    end
    @runde += 1
    @gegner.each do |gegner|
      gegner.laufen()
    end
  end

  def sterben()
    @gegner.each do |gegner|
      gegner.sterben()
      if gegner.tot?() and gegner.heilen?()
        @spieler.heilen()
      end
    end
    @gegner.delete_if {|gegner| gegner.tot?()}
  end

  def verletzen()
    @gegner.each do |gegner|
      if gegner.amZiel?()
        @spieler.verleztWerden()
        gegner.teleportieren()
      end
    end
  end
  
  def verloren?()
    @gegner.any? {|gegner| gegner.amZiel?()}
  end

  def gewonnen?()
    @gegner.length == 0 and @rein == @gegnerZahl
  end
end

class GegnerLeben
  def initialize(lp, maxLp)
    @lp = lp
    @maxLp = maxLp
  end
  attr_reader :lp, :maxLp
end
