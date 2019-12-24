require 'GegnerErsteller'

class Siegesbedingung
  def initialize(gegnerErsteller, spieler, spielfeld)
    @baeume = []
    @gegnerErsteller = gegnerErsteller
    @spieler = spieler
    @spielfeld = spielfeld
  end

  def fortschritt()
    0
  end

  def gewonnen?()
    fortschritt >= 100
  end
  
  def pflanze(baum)
    @baeume.push(baum)
  end

  def gewonnenString()
    "du hast nach #{SpielRunde.runde} Runden gewonnen!"
  end
end
