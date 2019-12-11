require 'WegStueck'
require 'Feld'

class Spielfeld
  def initialize(spielfeld, start)
    @spielfeld = spielfeld
    @start = start
    @minSchaden = 0
    @maxSchaden = 0
    @gegnerZahl = 1
    @baumKoordinaten = []
  end

  attr_accessor :gegnerZahl
  attr_reader :start, :minSchaden, :maxSchaden

  def wellenBegin()
    @baumKoordinaten.each do |koordinate|
      baum = gibBaum(koordinate[0], koordinate[1])
      baum.wellenBeginn()
      boosten(baum)
    end
  end

  def boosten(koenig)
    if koenig.staerkeKoenig?()
      @baumKoordinaten.each {|bK2| gibBaum(bK2[0], bK2[1]).staerkeBoosten() if koenig.kannErreichen?(bK2)}        
    elsif koenig.geschwindigkeitKoenig?()
      @baumKoordinaten.each {|bK2| gibBaum(bK2[0], bK2[1]).geschwindigkeitBoosten() if koenig.kannErreichen?(bK2)}   
    elsif koenig.reichweiteKoenig?()
      @baumKoordinaten.each {|bK2| gibBaum(bK2[0], bK2[1]).reichweiteBoosten() if koenig.kannErreichen?(bK2)}        
    end
  end
  
  def istWeg?(x,y)
    @spielfeld[y][x].istWeg?()
  end

  def hatFeind?(x,y)
    (@spielfeld[y][x].istWeg?() and @spielfeld[y][x].hatFeind?())
  end

  def feindBild(x, y, xKlein, yKlein)
    @spielfeld[y][x].feindBild(xKlein, yKlein)
  end
  
  def istFeld?(x,y)
    (not @spielfeld[y][x].istWeg?())
  end
  
  def hatBaum?(x,y)
    (not @spielfeld[y][x].istWeg?() and @spielfeld[y][x].hatBaum?())
  end
  
  def gibBaum(x,y)
    @spielfeld[y][x].baum
  end

  def baumVordergrundFarbe(x, y, xKlein, yKlein)
    @spielfeld[y][x].baumVordergrundFarbe(xKlein, yKlein)
  end
  
  def baumHintergrundFarbe(x, y, xKlein, yKlein, farbe)
    @spielfeld[y][x].baumHintergrundFarbe(xKlein, yKlein, farbe)
  end
    
  def baumZeichen(x, y, xKlein, yKlein)
    @spielfeld[y][x].baumZeichen(xKlein, yKlein)
  end
    
  def hoehe()
    @spielfeld.length
  end

  def breite()
    @spielfeld[0].length
  end

  def feldAnzeigen(x,y)
    @spielfeld[y][x].anzeigen()
  end

  def feldFarbe(x,y)
    @spielfeld[y][x].farbe()
  end
  
  def schiessen(gegnerArray)
    @baumKoordinaten.each do |koordinaten|
      baum = @spielfeld[koordinaten[1]][koordinaten[0]].baum
      baum.laden()
      typ, position = baum.anvisieren(gegnerArray)
      reagieren(typ, position)
    end
  end

  def reagieren(typ, position)
    return if typ == :nichts
    if typ == :brennen
      @spielfeld[position[1]][position[0]].anzuenden
    end
  end

  def neuerFeind(maxleben)
    feind = Feind.new(maxleben, @start)
    @start.feinde.push(feind)
    feind
  end
  
  def pflanzeBaum(koordinaten, baum)
    unless @spielfeld[koordinaten[1]][koordinaten[0]].istWeg?()
      baum.pflanzen(koordinaten)
      @spielfeld[koordinaten[1]][koordinaten[0]].baum = baum
      @baumKoordinaten.push(koordinaten.dup)
    end
  end

end
