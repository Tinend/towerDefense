require 'WegStueck'
require 'FarbZeichen'
require 'farben'

class Feind
  
  MaxLaufErsparnis = 10
  
  PflanzenBild = [
    "\\ A /",
    "~(o)~",
    "/ V \\"
  ]
  WasserBild = [
    "   ) ",
    "  X  ",
    " (   "
  ]
  
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
    @vergifter = nil
    @vereisungsCounter = 0
    @start = wegStueck
    @krank = 0
    @infizierer = nil
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

  def erkranken(schaden, baum)
    neuKrank = schaden * (0.1 + @maxLeben / 100000.0)
    @infizierer = baum if neuKrank > @krank
    @krank = [@krank, neuKrank].max
  end
  
  def verlangsamen()
    @verlangsamungsCounter = Sonderfaehigkeit::GegnerMaxVerlangsamungsCounter
  end
  
  def vergiften(gift, baum)
    if gift > @gift
      @vergiftungsCounter = Sonderfaehigkeit::GegnerMaxVergiftungsCounter
      @gift = gift
      @vergifter = baum
    end
  end

  def vereisen()
    @vereisungsCounter = Sonderfaehigkeit::GegnerMaxVereisungsCounter
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
    krankSchaden = (@krank + rand(0)).to_i
    @leben -= krankSchaden
    @infizierer.gesamtSchaden += krankSchaden if krankSchaden > 0
    if @vergiftungsCounter > 0
      schaden = (@gift.to_f / @vergiftungsCounter + rand(0)).to_i
      @vergifter.gesamtSchaden += schaden
      @leben -= schaden
      @gift -= schaden
      @vergiftungsCounter -= 1
    end
    if @vereisungsCounter > 0
      @vereisungsCounter -= 1
      @verlangsamungsCounter -= 1 if @verlangsamungsCounter > 0
    elsif @verlangsamungsCounter > 0
      @bildNummer += 1 unless versteinert?()
      @laufErsparnis += @geschwindigkeit / 2
      @laufDistanz += @geschwindigkeit / 2
      @verlangsamungsCounter -= 1
    else
      @bildNummer += 2 unless versteinert?()
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
        if @wegStueck.brennen / Sonderfaehigkeit::GegnerVerbrennFaktor >= 1
          @leben -= @wegStueck.brennen / Sonderfaehigkeit::GegnerVerbrennFaktor
          @geschwindigkeit *= Sonderfaehigkeit::GegnerVerbrennungsVerlangsamung
        end
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
    if y == 2 and x == 2
      return FarbZeichen.new(Gelb, Gelb, " ")
    elsif y > 0 and 0 < x and x < 4
      return FarbZeichen.new(Rot, Rot, " ")      
    elsif x == 0 and y == (-@bildNummer / 26) % 3
      return FarbZeichen.new(Rot, Rot, " ")
    elsif x == 0
      return FarbZeichen.new(Blau, Blau, " ")
    elsif x == 4 and y == (-@bildNummer / 28) % 3
      return FarbZeichen.new(Rot, Rot, " ")
    elsif x == 4
      return FarbZeichen.new(Blau, Blau, " ")
    elsif x % 3 == (@bildNummer / 34) % 3
      return FarbZeichen.new(Rot, Rot, " ")
    else
      return FarbZeichen.new(Blau, Blau, " ")      
    end
  end

  def pflanzenBild(x, y)
    FarbZeichen.new(Gruen, Blau, PflanzenBild[y][x])
  end

  def wasserBild(x,y)
    FarbZeichen.new(Weiss, Blau, WasserBild[y][x])
  end
  
  def bild(x, y)
    if @typ == :feuer
      return feuerBild(x, y)
    elsif @typ == :pflanze
      return pflanzenBild(x, y)
    elsif @typ == :wasser
      return wasserBild(x, y)
    end
  end
end
