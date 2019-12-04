require 'AktiveLeiste'
require 'InaktiveLeiste'
require 'GegnerErsteller'

class Leiste
  def initialize(hoehe, breite, gegnerErsteller)
    @inaktiveLeiste = InaktiveLeiste.new(hoehe, breite)
    @gegnerErsteller = gegnerErsteller
    @aktiveLeiste = AktiveLeiste.new(hoehe, breite, gegnerErsteller)
  end

  def aktivAnzeigen(baum, treffer)
    @aktiveLeiste.anzeigen(baum, treffer)
  end

  def aktivieren(baumLevel)
    @aktiveLeiste.oeffnen(baumLevel)
  end

  def deaktivieren()
    @aktiveLeiste.schliessen()
  end
end
