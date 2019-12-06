require 'AktiveLeiste'
require 'InaktiveLeiste'
require 'GegnerErsteller'

class Leiste
  def initialize(hoehe, breite, gegnerErsteller, spieler)
    @inaktiveLeiste = InaktiveLeiste.new(hoehe, breite, spieler)
    @gegnerErsteller = gegnerErsteller
    @aktiveLeiste = AktiveLeiste.new(hoehe, breite, gegnerErsteller, spieler)
  end

  def aktivAnzeigen(baum)
    @aktiveLeiste.anzeigen(baum)
  end

  def inaktivieren(gegnerArray)
    @inaktiveLeiste.anschalten(gegnerArray)
  end

  def inaktivAnzeigen()
    @inaktiveLeiste.anzeigen()
  end

  def inaktivOeffnen()
    @inaktiveLeiste.oeffnen()
  end

  def inaktivSchliessen()
    @inaktiveLeiste.schliessen()
  end
  
  def aktivieren(baumLevel)
    @aktiveLeiste.oeffnen(baumLevel)
  end

  def deaktivieren()
    @aktiveLeiste.schliessen()
  end

  def bauPhaseAnfangen()
    @aktiveLeiste.bauPhase = true
  end

  def bauPhaseBeenden()
    @aktiveLeiste.bauPhase = false
  end
end
