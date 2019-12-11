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
    @bildNummer = maxLeben
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
    neuKrank = schaden * (0.1 + @maxLeben / 100000.0)
    @krank = [@krank, neuKrank].max
  end
  
  def verlangsamen()
    @verlangsamungsCounter = MaxVerlangsamungsCounter
  end
  
  def vergiften(gift)
    if gift > @gift
      @vergiftungsCounter = MaxVergiftungsCounter
      @gift = gift
    end
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
    @leben -= (@krank + rand(0)).to_i
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
      @bildNummer += 1
      @laufErsparnis += @geschwindigkeit / 2
      @laufDistanz += @geschwindigkeit / 2
      @verlangsamungsCounter -= 1
    else
      @bildNummer += 2
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

  def feuerBild(x, y)
    
  end
  
  def bild(x, y)
    if @typ == :feuer
      feuerBild(x, y)
    elsif @typ == :pflanze
      pflanzenBild(x, y)
    elsif @typ == :wasser
      wasserBild(x, y)
    end
  end
end
