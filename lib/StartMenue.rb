# coding: utf-8
require 'Menue'

class StartMenue
  def initialize(array, hoehe, breite, verschiebungx, verschiebungy, feldFenster, gegnerErsteller, baumErsteller, spieler)
    @spieler = spieler
    @menue = Menue.new(array, hoehe, breite, verschiebungx, verschiebungy, feldFenster)
    @gegnerErsteller = gegnerErsteller
    @baumErsteller = baumErsteller
  end

  def auswaehlen()
    begin
      @menue.oeffnen()
      wahl = @menue.auswaehlen()
    ensure
      @menue.schliessen()
    end
    if wahl == "Einfach"
      waehleEinfach()
    elsif wahl == "Mittel"
      waehleMittel()
    elsif wahl == "Schwierig"
      waehleSchwierig()
    elsif wahl == "Ultra"
      waehleUltra()
    end
  end

  def waehleEinfach()
    @gegnerErsteller.staerkePolynom = [11.1, 12]
    @spieler.leben = 50
  end

  def waehleMittel()
    @gegnerErsteller.staerkePolynom = [0.25, 12, 3]
    @spieler.leben = 30
  end

  def waehleSchwierig()
    @gegnerErsteller.staerkePolynom = [0.5, 10, 3]
    @spieler.leben = 20
  end
  
  def waehleUltra()
    @gegnerErsteller.staerkePolynom = [0.03, -0.6, 20, 60]
    @spieler.leben = 100
  end
end
