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

  def alleBoosten()
    @baumKoordinaten.each do |bK|
      boosten(bK)
    end
  end

  def boosten(bKKoenig)
    koenig = gibBaum(bKKoenig[0], bKKoenig[1])
    if koenig.staerkeKoenig?()
      @baumKoordinaten.each {|bK2| gibBaum(bK2[0], bK2[1]).staerkeBoosten() if koenig.kannErreichen?(bK2)}        
    elsif koenig.geschwindigkeitKoenig?()
      @baumKoordinaten.each {|bK2| gibBaum(bK2[0], bK2[1]).geschwindigkeitBoosten() if koenig.kannErreichen?(bK2)}   
    elsif koenig.reichweiteKoenig?()
      @baumKoordinaten.each {|bK2| gibBaum(bK2[0], bK2[1]).reichweiteBoosten() if koenig.kannErreichen?(bK2)}        
    end
  end
  
  def berechneTrefferArray(position, reichweite)
    treffer = []
    (2 * reichweite.to_i + 1).times do |xVerschiebung|
      x = position[0] + xVerschiebung - reichweite.to_i
      (2 * reichweite.to_i + 1).times do |yVerschiebung|
        y = position[1] + yVerschiebung - reichweite.to_i
        if (xVerschiebung - reichweite.to_i) ** 2 + (yVerschiebung - reichweite.to_i) ** 2 <= reichweite ** 2 and x >= 0 and y >= 0 and @spielfeld.length > y and @spielfeld[y].length > x and @spielfeld[y][x].istWeg?()
          treffer += @spielfeld[y][x].nummern()
        end
      end
    end
    treffer
  end
  
  def berechneTreffer(position, reichweite)
    treffer = berechneTrefferArray(position, reichweite)
    return [0,0] if treffer.length == 0
    minTreffer = treffer.length
    maxTreffer = 0
    treffer.sort!
    letzter = treffer[0] - @gegnerZahl
    treffer.each do |t|
      maxTreffer += [t - letzter, @gegnerZahl].min
      letzter = t
    end
    [minTreffer, maxTreffer]
  end
 
  def istWeg?(x,y)
    @spielfeld[y][x].istWeg?()
  end

  def hatFeind?(x,y)
    (@spielfeld[y][x].istWeg?() and @spielfeld[y][x].hatFeind?())
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

  def anzeigen()
    raise
    ausgabe = ""
    @spielfeld.each do |zeile|
      zeile.each do |feld|
        if feld.farbe == :rot
          ausgabe += feld.anzeigen().red
        elsif feld.farbe == :gruen
          ausgabe += feld.anzeigen().green
        else
          ausgabe += feld.anzeigen()
        end
      end
      ausgabe += "\n"
    end
    ausgabe
  end

  def schadenReduziert(koordinaten)
    if @spielfeld[koordinaten[1]][koordinaten[0]].istWeg?()
      return [@minSchaden, @maxSchaden]
    else
      baum = @spielfeld[koordinaten[1]][koordinaten[0]].baum
      min, max = berechneTreffer(koordinaten, baum.reichweite)
      min = @minSchaden - max * baum.schaden
      max = @maxSchaden - max * baum.schaden
      return [min, max]
    end
  end
  
  def pflanzeBaum(koordinaten, baum)
    unless @spielfeld[koordinaten[1]][koordinaten[0]].istWeg?()
      baum.pflanzen(koordinaten)
      @spielfeld[koordinaten[1]][koordinaten[0]].baum = baum
      @baumKoordinaten.push(koordinaten.dup)
    end
  end

end
