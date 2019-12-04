require 'WegStuecke'
require 'WegStueck'
require 'Feld'

class GewichteteRichtung
  def initialize(richtung, gewicht)
    @richtung = richtung
    @gewicht = gewicht
  end

  attr_reader :gewicht, :richtung
end

class FeldErsteller
  Leer = :leer
  Verbraucht = :verbraucht
  VertikalFrei = :vertikal
  HorizontalFrei = :horizontal
  RichtungBehaltenWkeit = 50
  Norden = GewichteteRichtung.new([0, 1], 9)
  Sueden = GewichteteRichtung.new([0, -1], 9)
  Osten = GewichteteRichtung.new([1, 0], 16)
  Westen = GewichteteRichtung.new([-1, 0], 6)
  
  def initialize(breite)
    @trys = 0
    @breite = breite
    zuruecksetzen()
    erstelleProvisorischesFeld()
    erstelleSpielfeld()
  end

  attr_reader :spielfeld, :start

  def zuruecksetzen()
    @trys += 1
    @provisorischesSpielfeld = Array.new(3) {
      neueZeile()
    }
    @position =  [0, 1]
    @nr = 0
    @start = nil
    @richtung = [1, 0]
    generiereWegstueck()
    bewege()
    generiereWegstueck()
    @fixrichtung = false
    @reset = false
  end
  
  def neueZeile()
    zeile = Array.new(@breite, Leer)
    zeile[0] = Verbraucht
    zeile
  end

  def generiereWegstueck()
    if @provisorischesSpielfeld[@position[1]][@position[0]] == VertikalFrei or @provisorischesSpielfeld[@position[1]][@position[0]] == HorizontalFrei or @provisorischesSpielfeld[@position[1]][@position[0]].class == WegStuecke
      @fixrichtung = true
    else @fixrichtung == false
      @fixrichtung = false
    end
    unless @provisorischesSpielfeld[@position[1]][@position[0]].class == WegStuecke
      @provisorischesSpielfeld[@position[1]][@position[0]] = WegStuecke.new()
    end
    @start = WegStueck.new(@start, @nr)
    @nr += 1
    @provisorischesSpielfeld[@position[1]][@position[0]].neuesWegStueck(@start)
  end
  
  def verschiebeUnten()
    @provisorischesSpielfeld.push(neueZeile)
  end

  def verschiebeOben()
    @provisorischesSpielfeld = [neueZeile()] + @provisorischesSpielfeld
    @position[1] += 1
    @altePosition[1] += 1
  end

  def moeglicheBewegung(richtung)
    return false if richtung[0] == -1 and @position[0] <= 1
    return false if richtung[0] == 1 and @position[0] == @breite - 1
    feld = @provisorischesSpielfeld[@position[1] + richtung[1]][@position[0] + richtung[0]]
    return true if feld == Leer
    return true if (richtung[0] != 0) and feld == HorizontalFrei
    return true if (richtung[1] != 0) and feld == VertikalFrei
    return true if feld.class == WegStuecke and feld.maxnr() < @nr - 2
    return false
  end

  def findeRichtung()
    richtungen = [Norden, Sueden, Osten, Westen]
    richtungen.delete_if {|gewichteteRichtung| not moeglicheBewegung(gewichteteRichtung.richtung)}
    if richtungen == []
      @reset = true
      return nil
    end
    sumGewicht = 0
    richtungen.each {|gewichteteRichtung| sumGewicht += gewichteteRichtung.gewicht}
    wahl = rand(sumGewicht)
    richtungen.each do |gewichteteRichtung|
      wahl -= gewichteteRichtung.gewicht
      if wahl < 0
        @richtung = gewichteteRichtung.richtung
        return nil
      end
    end
    raise
  end

  def markiereParallel(position)
    if @richtung[0] == 0
      markiere(position, HorizontalFrei)
    else
      markiere(position, VertikalFrei)      
    end
  end

  def senkrecht(richtung)
    if richtung == VertikalFrei
      return HorizontalFrei
    elsif richtung == HorizontalFrei
      return VertikalFrei
    else
      return false
    end
  end

  def markiere(position, richtung)
    feld = @provisorischesSpielfeld[position[1]][position[0]]
    if feld == Leer
      @provisorischesSpielfeld[position[1]][position[0]] = richtung
    elsif feld == senkrecht(richtung)
      @provisorischesSpielfeld[position[1]][position[0]] = Verbraucht
    elsif feld == VertikalFrei or feld == HorizontalFrei
      @provisorischesSpielfeld[position[1]][position[0]] = richtung
    end
  end

  def markiereNachbarn(position, richtung)
    markiereParallel([position[0] + richtung[1], position[1] + richtung[0]])
    markiereParallel([position[0] - richtung[1], position[1] - richtung[0]])
    markiere([position[0] - richtung[0], position[1] - richtung[1]], Verbraucht)
    markiere([position[0] + richtung[0], position[1] + richtung[1]], Verbraucht)
  end
  
  def bewege()
    if (rand(100) >= RichtungBehaltenWkeit or not moeglicheBewegung(@richtung)) and not @fixrichtung
      findeRichtung()
    elsif not moeglicheBewegung(@richtung)
      @reset = true
    end
    return nil if @reset
    if @richtung[1] == 1 and @position[1] == @provisorischesSpielfeld.length - 2
      verschiebeUnten()
    elsif @richtung[1] == -1 and @position[1] == 1
      verschiebeOben()
    end
    @position[0] += @richtung[0]
    @position[1] += @richtung[1]
  end
  
  def erstelleProvisorischesFeld()
    until @position[0] == @breite - 1
      alteRichtung = @richtung.dup
      if @reset
        zuruecksetzen() 
      end
      @altePosition = @position.dup
      bewege()
      next if @reset
      generiereWegstueck()
      markiereNachbarn(@altePosition, @richtung)
      markiereNachbarn(@altePosition, alteRichtung)
    end
  end

  def erstelleSpielfeld()
    [0, 9 - @provisorischesSpielfeld.length / 2].max.times do
    verschiebeUnten()
      verschiebeOben()
    end
    @spielfeld = []
    @provisorischesSpielfeld.each_with_index do |zeile, y|
      @spielfeld.push([])
      zeile.each_with_index do |feldstueck, x|
        if feldstueck.class == WegStuecke
          feldstueck.positioniere(x, y)
          @spielfeld[-1].push(feldstueck)
        else
          @spielfeld[-1].push(Feld.new())
        end
      end
    end
  end
end
