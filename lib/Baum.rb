require 'Upgrades'
require 'GegnerSortierer'
require 'ordnung/StandardGegnerOrdnung'
require 'ordnung/VerlangsamungsGegnerOrdnung'
require 'ordnung/VergiftungsGegnerOrdnung'
require 'ordnung/VereisungsGegnerOrdnung'
require 'ordnung/KrankheitsGegnerOrdnung'
require 'ordnung/ProzentSchadensGegnerOrdnung'
require 'ordnung/MultiOrdnung'
require 'Sonderfaehigkeiten'

class Baum
  MaxLaden = 10
  LadenBoostLevel1 = 2
  LadenBoostLevel2 = 5
  SchnellLadenStaerkeMalusLevel2 = 0.5
  AllroundLadeBoost = 1
  AllroundStaerkeBoost = 1.2
  AllroundReichweiteBoost = 1
  GrundSchaden = 10
  EffektivBonus = 5
  IneffektivMalus = 2
  StaerkeBoostLevel1 = 1.4
  StaerkeBoostLevel2 = 2
  ReichweiteBoostLevel1 = 1
  ReichweiteBoostLevel2 = 2
  ReichweiteBoostLevel3 = 3
  ReichweiteBoostLevel4 = 4
  EffektivBoost = 4
  DoppelWkeit = 0.5
  VereisungsWkeit = 0.01
  InstaDeathWkeit = 0.01
  TeleportationsWkeit = 0.01
  VersteinerungsWkeit = 0.01
  ProzentLP = 10.0
  KoenigsReichweiteBoost = 1
  KoenigsGeschwindigkeitsBoost = 1
  KoenigsStaerkeBoost = 1.1
  
  def initialize(reichweite, position)
    @reichweite = reichweite
    @upgrades = Upgrades.new()
    @geladen = MaxLaden
    @position = [0, 0]
    @reichweiteBoost = false
    @geschwindigkeitsBoost = false
    @staerkeBoost = false
  end

  def staerkeBoosten()
    @staerkeBoost = true unless koenig?()
  end

  def staerkeKoenig?()
    @upgrades.upgrade?(StaerkeKoenigSonderfaehigkeit.bedingung)
  end
  
  def geschwindigkeitBoosten()
    @geschwindigkeitsBoost = true unless koenig?()
  end

  def geschwindigkeitKoenig?()
    @upgrades.upgrade?(SchnellLadenKoenigSonderfaehigkeit.bedingung)
  end
  
  def reichweiteBoosten()
    @reichweiteBoost = true unless koenig?()
  end

  def reichweiteKoenig?()
    @upgrades.upgrade?(ReichweiteKoenigSonderfaehigkeit.bedingung)
  end
  
  def koenig?()
    staerkeKoenig?() or geschwindigkeitKoenig?() or reichweiteKoenig?()
  end

  def kannErreichen?(position)
    ((position[0] - @position[0]) ** 2 + (position[1] - @position[1]) ** 2 <= reichweite() ** 2)
  end
  
  def pflanzen(position)
    @position = position.dup
  end

  def reichweite()
    r = @reichweite
    r += ReichweiteBoostLevel1 if @upgrades.upgrade?(ReichweiteSonderfaehigkeit.bedingung())
    r += ReichweiteBoostLevel2 if @upgrades.upgrade?(Reichweite2Sonderfaehigkeit.bedingung())
    r += ReichweiteBoostLevel3 if @upgrades.upgrade?(Reichweite3Sonderfaehigkeit.bedingung())
    r += ReichweiteBoostLevel4 if @upgrades.upgrade?(Reichweite4Sonderfaehigkeit.bedingung())
    r += AllroundReichweiteBoost if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
    r += KoenigsReichweiteBoost if @reichweiteBoost and not koenig?()
   return r
  end
  
  def laden()
    @geladen += 1
  end

  def maxLaden()
    ladeZeit = MaxLaden
    ladeZeit -= LadenBoostLevel1 if @upgrades.upgrade?(SchnellLadenSondefaehigkeit.bedingung)
    ladeZeit -= LadenBoostLevel2 if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung)
    ladeZeit -= AllroundLadeBoost if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
    ladeZeit -= KoenigsGeschwindigkeitsBoost if @geschwindigkeitsBoost
    [ladeZeit, 1].max
  end

  def entladen()
    @geladen -= maxLaden()
  end

  def nichtUeberladen()
    @geladen = [maxLaden(), @geladen].min
  end
  
  def geladen?()
    @reichweite > 0 and @geladen >= maxLaden()
  end

  def zielenEinzel(gegnerArray)
    if @upgrades.upgrade?(ProzentSchadenSondefaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(ProzentSchadensGegnerOrdnung)
    elsif @upgrades.upgrade?(VerlangsamungsSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(VerlangsamungsGegnerOrdnung)
    elsif @upgrades.upgrade?(VergiftungsSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(VergiftungsGegnerOrdnung)
    elsif @upgrades.upgrade?(VereisungsSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(VereisungsGegnerOrdnung)
    elsif @upgrades.upgrade?(KrankheitSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(KrankheitsGegnerOrdnung)
    else
      gegnerSortierer = GegnerSortierer.new(StandardGegnerOrdnung)
    end
    gegnerSortierer.zielFinden(@position, reichweite(), gegnerArray)
  end

  def zielenMultipel(gegnerArray)
    gegnerSortierer = GegnerSortierer.new(MultiOrdnung)
    ziele = gegnerSortierer.multiZielFinden(@position, reichweite(), gegnerArray)
    ziele.each do |ziel|
      schiessen(ziel)
    end
    return [:brennen, ziele[0].position] if @upgrades.upgrade?(BrandSonderfaehigkeit.bedingung)
    return [:nichts, [0, 0]]
  end
  
  def anvisieren(gegnerArray)
    return unless geladen?()
    return if koenig?()
    if @upgrades.upgrade?(SplashSonderfaehigkeit.bedingung)
      return zielenMultipel(gegnerArray)
    else
      ziel = zielenEinzel(gegnerArray)
      return if ziel == nil
      schiessen(ziel)
      @geladen -= maxLaden()
      return [:brennen, ziel.position] if @upgrades.upgrade?(BrandSonderfaehigkeit.bedingung)
      return [:nichts, [0, 0]]
    end
  end

  def schiessen(ziel)
    schaden = berechneSchaden(ziel.typ, ziel.leben)
    schaden *= 2 if rand(0) <= DoppelWkeit and @upgrades.upgrade?(DoppelterSchadenSonderfaehigkeit.bedingung)
    ziel.leben -= schaden
    ziel.verlangsamen() if @upgrades.upgrade?(VerlangsamungsSonderfaehigkeit.bedingung)
    ziel.vergiften(schaden) if @upgrades.upgrade?(VergiftungsSonderfaehigkeit.bedingung)
    ziel.vereisen() if @upgrades.upgrade?(VereisungsSonderfaehigkeit.bedingung) and rand(0) < VereisungsWkeit
    ziel.toeten() if @upgrades.upgrade?(InstaDeathSonderfaehigkeit.bedingung) and rand(0) < InstaDeathWkeit
    ziel.teleportieren() if @upgrades.upgrade?(TeleportationSonderfaehigkeit.bedingung) and rand(0) < TeleportationsWkeit
    ziel.versteinern() if @upgrades.upgrade?(VersteinerungSonderfaehigkeit.bedingung) and rand(0) < VersteinerungsWkeit
    ziel.anzuenden() if @upgrades.upgrade?(BrandSonderfaehigkeit.bedingung)
    ziel.erkranken(schaden) if @upgrades.upgrade?(KrankheitSonderfaehigkeit.bedingung)
  end
  
  def berechneSchaden(typ, lp = 0)
    schaden = GrundSchaden
    schaden = [lp * ProzentLP / 100, schaden].max() if @upgrades.upgrade?(ProzentSchadenSondefaehigkeit.bedingung)
    schaden *= KoenigsStaerkeBoost if @staerkeBoost
    effektivitaetsFaktor = @upgrades.effektivitaetsfaktor()
    effektivitaetsFaktor = EffektivBoost if @upgrades.upgrade?(SchwaechenStaerkerSonderfaehigkeit.bedingung)
    if @upgrades.upgrades.length >= 1
      schaden += EffektivBonus * effektivitaetsFaktor if effektiv?(@upgrades.typ, typ)
      schaden -= IneffektivMalus * effektivitaetsFaktor if ineffektiv?(@upgrades.typ, typ)
    end
    schaden *= StaerkeBoostLevel1 if @upgrades.upgrade?(StaerkeSonderfaehigkeit.bedingung)
    schaden *= StaerkeBoostLevel2 if @upgrades.upgrade?(Staerke2Sonderfaehigkeit.bedingung)
    schaden *= SchnellLadenStaerkeMalusLevel2 if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung)
    schaden *= AllroundStaerkeBoost if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
    [(schaden + 0.5).to_i, 1].max
  end

  def effektiv?(angriffsTyp, verteidigungsTyp)
    (angriffsTyp == :pflanze and verteidigungsTyp == :wasser) or (angriffsTyp == :wasser and verteidigungsTyp == :feuer) or (angriffsTyp == :feuer and verteidigungsTyp == :pflanze)
  end

  def ineffektiv?(angriffsTyp, verteidigungsTyp)
    effektiv?(verteidigungsTyp, angriffsTyp)
  end
  
  def level()
    @upgrades.level()
  end
  
  def upgraden(typ)
    @upgrades.upgraden(typ)
  end

  def downgraden()
    @upgrades.downgraden()
  end

  def vordergrundFarbe(x, y)
    @upgrades.berechneUpgradeVordergrundFarbe(x, y, Magenta)
  end

  def upgradeFarbe(upgradeNummer)
    @upgrades.upgradeFarbe(upgradeNummer)
  end
  
  def hintergrundFarbe(x, y, farbe)
    @upgrades.berechneUpgradeHintergrundFarbe(x, y, farbe)
  end

  def zeichen(x, y)
    z = ""
    if x == 2 and y == 1
      z = "O"
    elsif x == 2
      z = "|"
    elsif y == 1
      z = "-"
    else
      z = " "
    end
    @upgrades.berechneUpgradeZeichen(x, y, z)
  end

  def sonderfaehigkeiten()
    @upgrades.sonderfaehigkeiten
  end
end
