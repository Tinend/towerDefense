require 'GegnerArray'

class GegnerErsteller
  Typen = [:wasser, :pflanze, :feuer]
  GeschwindigkeitAnzahlVerstaerkungsFaktor = 1.5
  WenigeFeindeBonus = 8
  AnzahlMalusBasis = 0.7  
  PflanzenKoeffizient = 1.5
  WasserAnzahlSteigerung = 0.1
  PflanzenGeschwindigkeit = 0.1
  WasserGeschwindigkeit = 0.12
  FeuerGeschwindigkeit = 0.2
  FeuerSchnellerWerden = 0.1
  
  def initialize(start, spieler)
    @start = start
    @spieler = spieler
    @anzahl = 1
    @faktor = 1
    @staerkePolynom = [1, 1, -1]
    @typ = rand(3)
    @staerke = 1
    @geschwindigkeit = 1
  end

  attr_accessor :staerkePolynom
  attr_reader :anzahl, :staerke, :geschwindigkeit

  def typ()
    Typen[@typ % 3]
  end
  
  def definiereGegner()
    if typ() == :feuer
      feuerErstellen()
    elsif typ() == :pflanze
      pflanzeErstellen()
    elsif typ() == :wasser
      wasserErstellen()
    end
  end

  def erstelleGeschwindigkeit(gesFaktor)
    (1 - rand(0) ** gesFaktor) * 9.5 + 0.5
  end
  
  def erstelleGegner()
    @array = GegnerArray.new(@start, @anzahl, @staerke, typ(), @geschwindigkeit, @spieler)
    @typ += 1
    @array
  end

  def gesamtLp()
    staerke = @staerkePolynom.reduce(0) {|wert, koeffizient| wert * SpielRunde.runde + koeffizient}
    staerke * @anzahl
  end

  def feuerGeschwindigkeit()
    FeuerGeschwindigkeit + FeuerSchnellerWerden * SpielRunde.runde ** 0.5
  end

  def grundSchaden(runde)
    @staerkePolynom.reduce(0) {|wert, koeffizient| wert * runde + koeffizient}
  end
  
  def feuerErstellen()
    @staerke = grundSchaden(SpielRunde.runde)
    @anzahl = 1 + rand(2)
    until rand(4) == 0
      @anzahl += 1
    end
    @geschwindigkeit = erstelleGeschwindigkeit(feuerGeschwindigkeit())
    @staerke *= 1.5 + 2.0 / @geschwindigkeit / @anzahl
    @staerke = @staerke.to_i
  end

  def wasserErstellen()
    @staerke = grundSchaden(SpielRunde.runde)
    @anzahl = 1 + rand(4)
    until rand(0) * (5 + WasserAnzahlSteigerung * SpielRunde.runde) < 1
      @anzahl += 1
    end
    @geschwindigkeit = erstelleGeschwindigkeit(WasserGeschwindigkeit)
    @staerke *= (1 + (GeschwindigkeitAnzahlVerstaerkungsFaktor + WenigeFeindeBonus * AnzahlMalusBasis ** @anzahl) / @geschwindigkeit / @anzahl)
    @staerke = @staerke.to_i
  end
  
  def pflanzeErstellen()
    @staerke = grundSchaden(SpielRunde.runde * 1.5)
    @anzahl = 1
    until rand(2) == 0
      @anzahl += 1
    end
    @geschwindigkeit = erstelleGeschwindigkeit(PflanzenGeschwindigkeit)
    @staerke *= 1.5 + 2.0 / @geschwindigkeit / @anzahl
    @staerke = @staerke.to_i
  end
end
