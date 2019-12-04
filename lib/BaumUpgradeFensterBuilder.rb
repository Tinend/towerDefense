require 'BaumUpgradeFenster'

class BaumUpgradeFensterBuilder
  def initialize()
  end

  def waehlen(baum)
    begin
      @fenster.oeffnen(baum)
      wahl = @fenster.auswaehlen()
      return wahl
    ensure
      @fenster.schliessen()
    end
  end
  
  def erstelle(hoehe, breite, verschiebungy, verschiebungx, hauptfenster)
    @fenster = BaumUpgradeFenster.new(hoehe, breite, verschiebungy, verschiebungx, hauptfenster)
  end
end
