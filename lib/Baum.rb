# coding: utf-8
require 'Upgrades'
require 'GegnerSortierer'
require 'ordnung/StandardGegnerOrdnung'
require 'ordnung/VerlangsamungsGegnerOrdnung'
require 'ordnung/VergiftungsGegnerOrdnung'
require 'ordnung/VereisungsGegnerOrdnung'
require 'ordnung/KrankheitsGegnerOrdnung'
require 'ordnung/ProzentSchadensGegnerOrdnung'
require 'ordnung/HeilungsGegnerOrdnung'
require 'ordnung/MultiOrdnung'
require 'Sonderfaehigkeiten'

class Baum
  MaxLaden = 10
  LadenBoostLevel1 = 2
  LadenBoostLevel2 = 6
  SchnellLadenStaerkeMalusLevel2 = 0.4
  AllroundLadeBoost = 2
  AllroundStaerkeBoost = 1.3
  AllroundReichweiteBoost = 1
  GrundSchaden = 10
  EffektivBoni = [5, 22, 58, 35]
  IneffektivMali = [2, 4, 6, 8]
  StaerkeBoostLevel1 = 4.0 / 3
  StaerkeWachsen = 0.1
  ReichweiteBoostLevel1 = 1
  ReichweiteBoostLevel2 = 2
  ReichweiteBoostLevel3 = 3
  ReichweiteLevel4StaerkeBoost = 1
  DoppelWkeit = 0.5
  VereisungsWkeit = 0.015
  InstaDeathWkeit = 0.025
  TeleportationsWkeit = 0.03
  VersteinerungsWkeit = 0.025
  ProzentLP = 3.0
  KoenigsReichweiteBoost = 1
  KoenigsGeschwindigkeitsBoost = 1
  KoenigsStaerkeBoost = 1.25
  UpgradeNummer = {:feuer => 0, :pflanze => 1, :wasser => 2}
  ErhoehungsAnzahl = 3
  GeschwindigkeitsAnzahlBoost = 3
  ReichweiteAnzahlBoost = 1
  AllroundAnzahlBoost = 2
  
  @@upgrades = Array.new(81, 0)
  @@reichweiteErhoehenAnzahlBonus = false # Bonus für viele +Reichweite Upgrades
  @@GeschwindigkeitSteigernAnzahlBonus = false # Bonus für viele +Geschwindigkeit Upgrades
  
  def initialize(reichweite, position)
    @reichweite = reichweite
    @upgrades = Upgrades.new()
    @geladen = MaxLaden
    @position = [0, 0]
    @reichweiteBoost = false
    @geschwindigkeitsBoost = false
    @staerkeBoost = false
    @welle = 0
  end

  attr_reader :staerkeBoost, :geschwindigkeitsBoost, :reichweiteBoost

  def wellenBeginn()
    @welle += 1
  end
  
  def hatUpgrade?(bedingung)
    @upgrades.upgrade?(bedingung)
  end
    
  def staerkeBoosten()
    @staerkeBoost = true
  end

  def staerkeKoenig?()
    @upgrades.upgrade?(StaerkeKoenigSonderfaehigkeit.bedingung)
  end
  
  def geschwindigkeitBoosten()
    @geschwindigkeitsBoost = true
  end

  def geschwindigkeitKoenig?()
    @upgrades.upgrade?(SchnellLadenKoenigSonderfaehigkeit.bedingung)
  end
  
  def reichweiteBoosten()
    @reichweiteBoost = true
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
    r += @@upgrades[upgradsInZahl()] if @upgrades.upgrade?(Reichweite4Sonderfaehigkeit.bedingung())
    if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
      allroundFaktor = 1
      allroundFaktor = AllroundAnzahlBoost if @@upgrades[upgradsInZahl()] >= ErhoehungsAnzahl
      r += AllroundReichweiteBoost * allroundFaktor
    end
    r += KoenigsReichweiteBoost if @reichweiteBoost or reichweiteKoenig?()
    r += ReichweiteAnzahlBoost if @@reichweiteErhoehenAnzahlBonus
    return r
  end
  
  def laden()
    @geladen = [maxLaden() + 1, @geladen + 1].min
  end

  def maxLaden()
    ladeZeit = MaxLaden
    ladeZeit -= LadenBoostLevel1 if @upgrades.upgrade?(SchnellLadenSondefaehigkeit.bedingung)
    ladeZeit -= LadenBoostLevel2 if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung)
    if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
      allroundFaktor = 1
      allroundFaktor = AllroundAnzahlBoost if @@upgrades[upgradsInZahl()] >= ErhoehungsAnzahl
      ladeZeit -= AllroundLadeBoost * allroundFaktor
    end
    ladeZeit -= KoenigsGeschwindigkeitsBoost if @geschwindigkeitsBoost
    ladeZeit -= GeschwindigkeitsAnzahlBoost if @@GeschwindigkeitSteigernAnzahlBonus
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
    if @upgrades.upgrade?(VergiftungsSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(VergiftungsGegnerOrdnung)
    elsif @upgrades.upgrade?(ProzentSchadenSondefaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(ProzentSchadensGegnerOrdnung)
    elsif @upgrades.upgrade?(VerlangsamungsSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(VerlangsamungsGegnerOrdnung)
    elsif @upgrades.upgrade?(VereisungsSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(VereisungsGegnerOrdnung)
    elsif @upgrades.upgrade?(KrankheitSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(KrankheitsGegnerOrdnung)
    elsif @upgrades.upgrade?(HeilungsSonderfaehigkeit.bedingung)
      gegnerSortierer = GegnerSortierer.new(HeilungsGegnerOrdnung)
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
    ziel.heile(schaden) if @upgrades.upgrade?(HeilungsSonderfaehigkeit.bedingung)
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
    schaden += ReichweiteLevel4StaerkeBoost * @@upgrades[upgradsInZahl()] if @upgrades.upgrade?(Reichweite4Sonderfaehigkeit.bedingung())
    effektivitaetsLevel = @upgrades.effektivitaetsLevel()
    effektivitaetsLevel = 4 if @upgrades.upgrade?(SchwaechenStaerkerSonderfaehigkeit.bedingung)    
    if @upgrades.upgrades.length >= 1
      schaden += EffektivBoni[effektivitaetsLevel - 1] if effektiv?(@upgrades.typ, typ)
      schaden -= IneffektivMali[effektivitaetsLevel - 1] if ineffektiv?(@upgrades.typ, typ)
    end
    schaden *= KoenigsStaerkeBoost if @staerkeBoost
    schaden *= (1 + lp * ProzentLP / 1000) if @upgrades.upgrade?(ProzentSchadenSondefaehigkeit.bedingung)
    schaden *= StaerkeBoostLevel1 if @upgrades.upgrade?(StaerkeSonderfaehigkeit.bedingung)
    schaden *= (1 + StaerkeWachsen * @welle) if @upgrades.upgrade?(StaerkeWachsenSonderfaehigkeit.bedingung)
    schaden *= (1 - SchnellLadenStaerkeMalusLevel2) if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung)
    if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
      allroundFaktor = AllroundStaerkeBoost
      allroundFaktor = (AllroundStaerkeBoost - 1) * AllroundAnzahlBoost + 1 if @@upgrades[upgradsInZahl()] >= ErhoehungsAnzahl
      schaden *= AllroundStaerkeBoost 
    end
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

  def upgradsInZahl()
    @upgrades.upgrades.reduce(0) {|wert, upgrade| wert * 3 + UpgradeNummer[upgrade]}
  end
  
  def upgraden(typ)
    @welle = 0
    @upgrades.upgraden(typ)
    if level == 4
      @@upgrades[upgradsInZahl()] += 1
      @@reichweiteErhoehenAnzahlBonus = true if @upgrades.upgrade?(Reichweite3Sonderfaehigkeit.bedingung()) and @@upgrades[upgradsInZahl()] >= ErhoehungsAnzahl
      @@GeschwindigkeitSteigernAnzahlBonus = true if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung) and @@upgrades[upgradsInZahl()] >= ErhoehungsAnzahl
    end
  end

  def downgraden()
    if level == 4
      @@upgrades[upgradsInZahl()] -= 1
      @@reichweiteErhoehenAnzahlBonus = testeAnzahlBonus(Reichweite3Sonderfaehigkeit.bedingung()) if @upgrades.upgrade?(Reichweite3Sonderfaehigkeit.bedingung()) and @@upgrades[upgradsInZahl()] == ErhoehungsAnzahl - 1
      @@GeschwindigkeitSteigernAnzahlBonus = testeAnzahlBonus(SchnellLaden2Sondefaehigkeit.bedingung) if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung) and @@upgrades[upgradsInZahl()] == ErhoehungsAnzahl - 1
    end
    @upgrades.downgraden()
  end

  def testeAnzahlBonus(array)
    array.permutation.to_a.any? {|permutation|
      testZahl = permutation.reduce(0) {|wert, upgrade| wert * 3 + UpgradeNummer[upgrade]}
      @@upgrades[testZahl] >= ErhoehungsAnzahl
    }
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
