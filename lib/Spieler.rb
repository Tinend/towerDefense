# coding: utf-8
class Spieler
  
  MaxLeben = 20
  TurmKosten = 10
  UpgradeKosten = [1, 6, 13, 40]
  GoldProRunde = 20
  
  def initialize()
    @leben = MaxLeben
    @gold = 20
    @gold += 1000 # entfernen
  end

  attr_accessor :leben
  attr_reader :gold

  def verloren?()
    @leben <= 0
  end

  def verleztWerden()
    @leben -= 1
  end

  def heilen()
    @leben += 1
  end

  def herz()
    mittelZeile = " " * (4 - (@leben.to_s.length + 1) / 2) + @leben.to_s + ""
    [
      "       ",
      mittelZeile,
      "       ",
      "       "
    ]
  end

  def kannTurmBauen?()
    @gold >= TurmKosten
  end
  
  def turmBauKosten()
    TurmKosten
  end
  
  def turmBezahlen()
    @gold -= turmBauKosten()
  end

  def turmUpgradebar?(level)
    @gold >= upgradeKosten(level)
  end
  
  def upgradeKosten(level)
    UpgradeKosten[level - 1]
  end

  def upgradeBezahlen(level)
    @gold -= upgradeKosten(level)
  end

  def runde()
    @gold += GoldProRunde
  end
end
