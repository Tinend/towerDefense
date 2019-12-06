require 'WegStueck'

class Feind
  MaxLaufErsparnis = 10
  MaxVerlangsamungsCounter = 30
  MaxVergiftungsCounter = 100
  MaxVereisungsCounter = 100
  VerbrennWkeit = 0.6
  MaxKrank = 100
 
  def initialize(maxLeben, wegStueck, typ, geschwindigkeit)
    @leben = maxLeben
    @maxLeben = maxLeben
    @wegStueck = wegStueck
    @typ = typ
    @handycaps = []
    @laufErsparnis = 0
    @laufDistanz = 0
    @geschwindigkeit = geschwindigkeit
    @verlangsamungsCounter = 0
    @vergiftungsCounter = 0
    @gift = 0
    @vereisungsCounter = 0
    @start = wegStueck
    @krank = 0
    @heilt = false
  end

  attr_accessor :leben
  attr_reader :typ, :laufDistanz, :verlangsamungsCounter, :vereisungsCounter, :vergiftungsCounter, :krank, :maxLeben

  def versteinert?()
    return @geschwindigkeit == 0
  end
  
  def position()
    if @wegStueck == nil
      return [-100, -100]
    else
      return @wegStueck.position
    end
  end
  
  def amZiel?()
    return @wegStueck == nil
  end

  def erkranken(schaden)
    @krank = [@krank, schaden].max
  end
  
  def verlangsamen()
    @verlangsamungsCounter = MaxVerlangsamungsCounter
  end
  
  def vergiften(gift)
    @vergiftungsCounter = MaxVergiftungsCounter
    @gift = gift
  end

  def vereisen()
    @vereisungsCounter = MaxVereisungsCounter
  end

  def versteinern()
    @geschwindigkeit = 0
  end

  def anzuenden()
    @wegStueck.anzuenden()
  end
  
  def teleportieren()
    return if @geschwindigkeit == 0
    @laufErsparnis = 0
    @laufDistanz = 0
    @wegStueck.feinde.delete(self) if @wegStueck != nil
    @wegStueck = @start
    @wegStueck.feinde.push(self)
  end
  
  def laufen()
    @leben -= 1 if @krank > rand(100)
    if @wegStueck.brennen and rand(0) <= VerbrennWkeit
      @leben -= 1
    end
    if @vergiftungsCounter > 0
      schaden = (@gift.to_f / @vergiftungsCounter + rand(0)).to_i
      @leben -= schaden
      @gift -= schaden
      @vergiftungsCounter -= 1
    end
    if @vereisungsCounter > 0
      @vereisungsCounter -= 1
      @verlangsamungsCounter -= 1 if @verlangsamungsCounter > 0
    elsif @verlangsamungsCounter > 0
      @laufErsparnis += @geschwindigkeit / 2
      @laufDistanz += @geschwindigkeit / 2
      @verlangsamungsCounter -= 1
    else
      @laufErsparnis += @geschwindigkeit
      @laufDistanz += @geschwindigkeit
    end
    schritt() if @laufErsparnis >= MaxLaufErsparnis
  end
  
  def schritt()
    @laufErsparnis -= MaxLaufErsparnis
    if @wegStueck != nil
      @wegStueck.feinde.delete(self)
      @wegStueck = @wegStueck.naechstes
      if @wegStueck != nil
        @wegStueck.feinde.push(self)
      end
    end
  end

  def anzeigen()
    @leben.to_s + "/" + @maxLeben.to_s
  end

  def tot?()
    @leben <= 0
  end

  def toeten()
    @leben = 0
  end

  def sterben()
    if tot? and @wegStueck != nil
      @wegStueck.feinde.delete(self)
    end
  end

  def heilen?()
    @heilen
  end

  def heile(staerke)
    if @leben > 0 and staerke >= @leben
      @heilen = true
    end
  end
end
