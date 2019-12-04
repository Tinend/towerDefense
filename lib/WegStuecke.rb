require 'WegStueck'

class WegStuecke
  def initialize()
    @wegStuecke = []
    @brennen = false
  end

  def anzuenden()
    @brennen = true
    @wegStuecke.each do |wS|
      wS.anzuenden()
    end
  end
  
  def positioniere(x, y)
    @wegStuecke.each do |wS|
      wS.position = [x, y]
    end
  end
  
  def nummern()
    nrs = []
    @wegStuecke.each do |wS|
      nrs.push(wS.nr)
    end
    nrs
  end
  
  def neuesWegStueck(wegStueck)
    @wegStuecke.push(wegStueck)
  end

  def istWeg?()
    true
  end

  def hatFeind?()
    @wegStuecke.any? {|wegStueck| wegStueck.hatFeind?()}
  end

  def leeren()
    @feinde.delete_if {|feind| feind.leben <= 0}
  end
  
  def anzeigen()
    "#"
  end
  
  def geeignet?()
    @wegStuecke.any? {|wegStueck| wegStueck.feinde.length > 0}
  end

  def nr()
    nummer = nil
    @wegStuecke.each do |ws|
      if ws.hatFeind? and (nummer == nil or nummer > ws.nr)
        nummer = ws.nr
      end
    end
    nummer
  end
  
  def maxnr()
    nr = 0
    @wegStuecke.each do |wegStueck|
      nr = [wegStueck.nr, nr].max
    end
    nr
  end

  def farbe()
    if @wegStuecke.all? {|wegStueck| wegStueck.feinde == []} and not @brennen
      return Weiss
    elsif @wegStuecke.all? {|wegStueck| wegStueck.feinde == []}
      return Rot
    else
      return Rot
    end
  end

  def wegStueck()
    ziel = nil
    @wegStuecke.each do |ws|
      if ws.feinde.length > 0 and (ziel == nil or ws.nr < ziel.nr)
        ziel = ws
      end
    end
    ziel
  end
end
