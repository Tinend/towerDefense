require 'siegesbedingungen/SchadenSiegesbedingung'
require 'siegesbedingungen/InstaDeathSiegesbedingung'

def erstelleSiegesbedingungen(gegnerErsteller, spieler, spielfeld)
  [
    SchadenSiegesbedingung.new(gegnerErsteller, spieler, spielfeld),
    InstaDeathSiegesbedingung.new(gegnerErsteller, spieler, spielfeld)
  ]
end
