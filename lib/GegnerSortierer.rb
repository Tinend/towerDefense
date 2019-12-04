class GegnerSortierer
  def initialize(ordnung)
    @ordnung = ordnung
  end

  def zielFinden(position, reichweite, gegnerArray)
    ordnungsArray = gegnerArray.gegner.map {|gegner| @ordnung.new(gegner)}
    ordnungsArray.delete_if{|ordnung|
      x, y = ordnung.gegner.position
      (x - position[0]) ** 2 + (y - position[1]) ** 2 > reichweite ** 2
    }
    return nil if ordnungsArray.length == 0
    ordnungsArray.sort!
    ordnungsArray[0].gegner
  end

  def multiZielFinden(position, reichweite, gegnerArray)
    ordnungsArray = gegnerArray.gegner.map {|gegner| @ordnung.new(gegner)}
    moeglicheZiele = ordnungsArray.reduce([]) do|array, ordnung|
      if array.length > 0 and array[-1].zusammenfuegbar(ordnung)
        array[-1] = array[-1] + ordnung
      else
        array.push(ordnung)
      end
      array
    end
    return [] if moeglicheZiele == []
    ziele = moeglicheZiele[0]
    moeglicheZiele.each do |mZ|
      ziele = mZ if mZ.gegner.length > ziele.gegner.length
    end
    return [] if weitWeg?(ziele.gegner[0].position, position, reichweite)
    ziele.gegner
  end

  def weitWeg?(pos1, pos2, reichweite)
    ((pos1[0] - pos2[0]) ** 2 + (pos1[1] - pos2[1]) ** 2 > reichweite ** 2)
  end
end
