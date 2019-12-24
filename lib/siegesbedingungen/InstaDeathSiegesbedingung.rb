# coding: utf-8
require 'siegesbedingungen/Siegesbedingung'
require 'Sonderfaehigkeiten'

class InstaDeathSiegesbedingung < Siegesbedingung

  def fortschritt()
    return 0 if SpielRunde.runde == 0
    wkeit = @baeume.reduce(1) do |wkeit, baum|
      wkeit *= (1 - Sonderfaehigkeit::InstaDeathWkeit) ** (10.0 / baum.maxLaden()) if baum.upgrades.upgrade?(InstaDeathSonderfaehigkeit.bedingung)
      wkeit *= (1 - Sonderfaehigkeit::TeleportationsWkeit) ** (10.0 / baum.maxLaden()) if baum.upgrades.upgrade?(TeleportationSonderfaehigkeit.bedingung)
      wkeit *= (1 - Sonderfaehigkeit::VersteinerungsWkeit) ** (10.0 / baum.maxLaden()) if baum.upgrades.upgrade?(VersteinerungSonderfaehigkeit.bedingung)
      wkeit
    end
    [SpielRunde.runde * 10, @spieler.leben * 20, (1 - wkeit) * 100.0 / 0.875].min
  end

  def gewonnenString()
    "Jeder Feind, der sich auf das Spielfeld wagt wird augenblicklick versteinert, von einem Feuerball zerschlagen oder in die Hölle teleportiert!\nDas Spiel ging #{SpielRunde.runde} Runden.\nHerzliche Gratulation zum Sieg!"
  end
end
