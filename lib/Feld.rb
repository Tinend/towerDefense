require 'Baum'

class Feld

  KeinBaum = Baum.new(0, [0, 0])
  
  def initialize()
    @baum = KeinBaum
  end

  attr_accessor :baum

  def istWeg?()
    false
  end

  def brennen()
    0
  end
  
  def anzeigen()
    baum.anzeigen()
  end

  def farbe()
    baum.farbe()
  end

  def hatBaum?()
    @baum != KeinBaum
  end

  def baumVordergrundFarbe(x, y)
    baum.vordergrundFarbe(x, y)
  end

  def baumHintergrundFarbe(x, y, farbe)
    baum.hintergrundFarbe(x, y, farbe)
  end
  
  def baumZeichen(x, y)
    baum.zeichen(x, y)
  end
end

