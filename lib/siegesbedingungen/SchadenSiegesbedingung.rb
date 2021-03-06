require 'siegesbedingungen/Siegesbedingung'
require 'Sonderfaehigkeiten'

class SchadenSiegesbedingung < Siegesbedingung

  SchadensFaktor = 2

  def fortschritt()
    return 0 if SpielRunde.runde == 0
    notwendigerSchaden = SchadensFaktor * @gegnerErsteller.grundSchaden(SpielRunde.runde + 1)
    plusSchaden = @spielfeld.summeFeuer()
    verursachterSchadenFeuer = @baeume.reduce(0) {|schaden, baum| schaden + baum.berechneSchaden(:feuer) / baum.maxLaden().to_f * 10}
    verursachterSchadenFeuer += plusSchaden
    verursachterSchadenFeuer = @baeume.reduce(verursachterSchadenFeuer) do |schaden, baum|
      schaden /= ((100 - baum.prozentSchaden(:feuer)) / 100) ** (10.0 / baum.maxLaden())
      schaden
    end
    verursachterSchadenPflanze = @baeume.reduce(0) {|schaden, baum| schaden + baum.berechneSchaden(:pflanze) / baum.maxLaden().to_f * 10}
    verursachterSchadenPflanze += plusSchaden
    verursachterSchadenPflanze = @baeume.reduce(verursachterSchadenPflanze) do |schaden, baum|
      schaden /= ((100 - baum.prozentSchaden(:pflanze)) / 100) ** (10.0 / baum.maxLaden())
      schaden
    end
    verursachterSchadenWasser = @baeume.reduce(0) {|schaden, baum| schaden + baum.berechneSchaden(:wasser) / baum.maxLaden().to_f * 10}
    verursachterSchadenWasser += plusSchaden
    verursachterSchadenWasser = @baeume.reduce(verursachterSchadenWasser) do |schaden, baum|
      schaden /= ((100 - baum.prozentSchaden(:wasser)) / 100) ** (10.0 / baum.maxLaden())
      schaden
    end
    [SpielRunde.runde * 10, @spieler.leben * 10, verursachterSchadenFeuer / notwendigerSchaden * 100, verursachterSchadenPflanze / notwendigerSchaden * 100, verursachterSchadenWasser / notwendigerSchaden * 100].min
  end

  def gewonnenString()
    "Mit brutaler Gewalt schmetterst du die Gegner nach #{SpielRunde.runde} Runden nieder!\nHerzliche Gratulation zum Sieg!"
  end
end
