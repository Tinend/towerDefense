require 'Feind'
require 'Sonderfaehigkeit'

class WegStueck
  
  def initialize(naechstes, nr)
    @nr = nr
    @naechstes = naechstes
    @feinde = []
    @position = [0, 0]
    @radioaktivitaet = 0
  end

  attr_reader :nr, :naechstes, :radioaktivitaet
  attr_accessor :feinde, :position
  
  def verstrahlen()
    @radioaktivitaet += 1
  end

  def nummern
    [@nr]
  end
  
  def farbe()
    if @feinde == [] and @radioaktivitaet < Sonderfaehigkeit::GegnerStrahlFaktor
      return Weiss
    elsif @feinde == []
      return Rot
    else
      return Rot
    end
  end
  
  def istWeg?()
    true
  end

  def hatFeind?() 
    (@feinde.length > 0)
  end

  def feindBild(x, y)
    @feinde[0].bild(x, y)
  end
  
  def leeren()
    @feinde.delete_if {|feind| feind.leben <= 0}
  end

  def geeignet?()
    @feinde.length > 0
  end

  def wegStueck()
    self
  end
end
