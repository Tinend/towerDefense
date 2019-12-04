# coding: utf-8
require 'Menue'

class StartMenue
  def initialize(array, hoehe, breite, verschiebungx, verschiebungy, feldFenster, gegnerErsteller, baumErsteller)
    @menue = Menue.new(array, hoehe, breite, verschiebungx, verschiebungy, feldFenster)
    @gegnerErsteller = gegnerErsteller
    @baumErsteller = baumErsteller
    @baumTypen = {}
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
    end
  end

  def waehleEinfach()
    @gegnerErsteller.staerkePolynom = [1, 10, -1]
    @baumErsteller.grundStaerke = 11
  end

  def waehleMittel()
    @gegnerErsteller.staerkePolynom = [2, 10, -2]
    @baumErsteller.grundStaerke = 10
  end

  def waehleSchwierig()
    @gegnerErsteller.staerkePolynom = [1, 0, 10, -1]
    @baumErsteller.grundStaerke = 9
  end
end
