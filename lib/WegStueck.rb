require 'Feind'

class WegStueck
  def initialize(naechstes, nr)
    @nr = nr
    @naechstes = naechstes
    @feinde = []
    @position = [0, 0]
    @brennen = false
  end

  attr_reader :nr, :naechstes, :brennen
  attr_accessor :feinde, :position
  
  def anzuenden()
    @brennen = true
  end

  def nummern
    [@nr]
  end
  
  def farbe()
    if @feinde == [] and not @brennen
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
