require 'Sonderfaehigkeiten'

class Upgrades
  def initialize()
    @upgrades = []
    @sonderfaehigkeiten = []
  end

  attr_reader :upgrades, :sonderfaehigkeiten

  def typ()
    @upgrades[0]
  end
  
  def upgrade?(upgradeArray)
    return false if upgradeArray.length > @upgrades.length
    vergleichsarray = upgradeArray.sort
    vergleichsarray == @upgrades[0..(vergleichsarray.length - 1)].sort
  end

  def effektivitaetsLevel()
    return 1 if @upgrades.length < 2 or @upgrades[0] != @upgrades[1]
    return 2 if @upgrades.length < 3 or @upgrades[1] != @upgrades[2]
    3
  end
  
  def level()
    return @upgrades.length
  end
  
  def upgraden(typ)
    @upgrades.push(typ)
    sonderfaehigkeiten = Level1Sonderfaehigkeiten if @upgrades.length == 1
    sonderfaehigkeiten = Level2Sonderfaehigkeiten if @upgrades.length == 2
    sonderfaehigkeiten = Level3Sonderfaehigkeiten if @upgrades.length == 3
    sonderfaehigkeiten = Level4Sonderfaehigkeiten if @upgrades.length == 4
    sonderfaehigkeiten.each do |sf|
      @sonderfaehigkeiten.push(sf) if upgrade?(sf.bedingung)
    end
  end

  def downgraden()
    @upgrades.pop()
    @sonderfaehigkeiten.pop() if @upgrades.length <= 3
  end
  
  def upgradeFarbe(upgradeNummer, farbe = berechneFarbe(Schwarz, Schwarz))
    return farbe if @upgrades.length <= upgradeNummer
    return Schwarz if upgradeNummer >= @upgrades.length
    if @upgrades[upgradeNummer] == :pflanze
      return Gruen
    elsif @upgrades[upgradeNummer] == :wasser
      return Blau
    elsif @upgrades[upgradeNummer] == :feuer
      return Rot
    end
    raise
  end

  def berechneUpgradeVordergrundFarbe(x, y, farbe)
    @sonderfaehigkeiten.reverse.each do |sf|
      vordergrundFarbe, hintergrundFarbe, zeichen = sf.aussehenAn(x, y)
      if zeichen != " "
        return vordergrundFarbe
      end
    end
    farbe
  end
  
  def berechneUpgradeHintergrundFarbe(x, y, farbe)
    @sonderfaehigkeiten.reverse.each do |sf|
      vordergrundFarbe, hintergrundFarbe, zeichen = sf.aussehenAn(x, y)
      if zeichen != " " and (farbe == Cyan or sf.hintergrundDurchsetzungsvermoegen)
        return hintergrundFarbe
      end
    end
    farbe
  end
  
  def berechneUpgradeZeichen(x, y, zeichen)
    @sonderfaehigkeiten.reverse.each do |sf|
      vordergundFarbe, hintergrundFarbe, zeichenSf = sf.aussehenAn(x, y)
      if zeichenSf != " "
        return zeichenSf
      end
    end
    zeichen
  end
end
