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
require 'Sonderfaehigkeit'

class Baum
  GrundSchaden = 10
  MaxLaden = 10
  UpgradeNummer = {:feuer => 0, :pflanze => 1, :wasser => 2}
  
  @@upgrades = Array.new(81, 0)
  @@reichweiteErhoehenAnzahlBonus = false # Bonus für viele +Reichweite Upgrades
  @@geschwindigkeitSteigernAnzahlBonus = false # Bonus für viele +Geschwindigkeit Upgrades
  @@maxVerursachterSchaden = 1 # Für Bonus für viele +Stärke Upgrades
  
  def initialize(reichweite, position)
    @reichweite = reichweite
    @upgrades = Upgrades.new()
    @geladen = MaxLaden
    @position = [0, 0]
    @reichweiteBoost = false
    @geschwindigkeitsBoost = false
    @staerkeBoost = false
    @welle = 0
    @gesamtSchaden = 0
  end

  attr_accessor :gesamtSchaden
  attr_reader :staerkeBoost, :geschwindigkeitsBoost, :reichweiteBoost, :upgrades

  def wellenBeginn()
    @@maxVerursachterSchaden = [@@maxVerursachterSchaden, @gesamtSchaden].max if @upgrades.upgrade?(StaerkeLevel2Sonderfaehigkeit.bedingung) and @@upgrades[upgradsInZahl()] >= Sonderfaehigkeit::ErhoehungsAnzahl
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
    r += Sonderfaehigkeit::ReichweiteBoostLevel1 if @upgrades.upgrade?(ReichweiteSonderfaehigkeit.bedingung())
    r += Sonderfaehigkeit::ReichweiteBoostLevel2 if @upgrades.upgrade?(Reichweite2Sonderfaehigkeit.bedingung())
    r += Sonderfaehigkeit::ReichweiteBoostLevel3 if @upgrades.upgrade?(Reichweite3Sonderfaehigkeit.bedingung())
    r += @@upgrades[upgradsInZahl()] if @upgrades.upgrade?(Reichweite4Sonderfaehigkeit.bedingung())
    if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
      allroundFaktor = 1
      allroundFaktor = Sonderfaehigkeit::AllroundAnzahlBoost if @@upgrades[upgradsInZahl()] >= Sonderfaehigkeit::ErhoehungsAnzahl
      r += Sonderfaehigkeit::AllroundReichweiteBoost * allroundFaktor
    end
    r += Sonderfaehigkeit::KoenigsReichweiteBoost if @reichweiteBoost or reichweiteKoenig?()
    r += Sonderfaehigkeit::ReichweiteAnzahlBoost if @@reichweiteErhoehenAnzahlBonus
    return r
  end
  
  def laden()
    @geladen = [maxLaden() + 1, @geladen + 1].min
  end

  def maxLaden()
    ladeZeit = MaxLaden
    ladeZeit -= Sonderfaehigkeit::LadenBoostLevel1 if @upgrades.upgrade?(SchnellLadenSondefaehigkeit.bedingung)
    ladeZeit -= Sonderfaehigkeit::LadenBoostLevel2 if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung)
    if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
      allroundFaktor = 1
      allroundFaktor = Sonderfaehigkeit::AllroundAnzahlBoost if @@upgrades[upgradsInZahl()] >= Sonderfaehigkeit::ErhoehungsAnzahl
      ladeZeit -= Sonderfaehigkeit::AllroundLadeBoost * allroundFaktor
    end
    ladeZeit -= Sonderfaehigkeit::KoenigsGeschwindigkeitsBoost if @geschwindigkeitsBoost
    ladeZeit -= Sonderfaehigkeit::GeschwindigkeitsAnzahlBoost if @@geschwindigkeitSteigernAnzahlBonus
    ladeZeit -= @@upgrades[upgradsInZahl()] / 10 if @upgrades.upgrade?(Reichweite4Sonderfaehigkeit.bedingung())
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
    @geladen -= maxLaden() if ziele != []
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
    schaden *= 2 if rand(0) <= Sonderfaehigkeit::DoppelWkeit and @upgrades.upgrade?(DoppelterSchadenSonderfaehigkeit.bedingung)
    ziel.heile(schaden) if @upgrades.upgrade?(HeilungsSonderfaehigkeit.bedingung)
    @gesamtSchaden += [[schaden, ziel.leben].min, 0].max
    ziel.leben -= schaden
    ziel.verlangsamen() if @upgrades.upgrade?(VerlangsamungsSonderfaehigkeit.bedingung)
    ziel.vergiften(schaden, self) if @upgrades.upgrade?(VergiftungsSonderfaehigkeit.bedingung)
    ziel.vereisen() if @upgrades.upgrade?(VereisungsSonderfaehigkeit.bedingung) and rand(0) < Sonderfaehigkeit::VereisungsWkeit
    if @upgrades.upgrade?(InstaDeathSonderfaehigkeit.bedingung) and rand(0) < Sonderfaehigkeit::InstaDeathWkeit
      @gesamtSchaden += [ziel.leben, 0].max
      ziel.toeten()
    end
    @@maxVerursachterSchaden = [@@maxVerursachterSchaden, @gesamtSchaden].max if @upgrades.upgrade?(StaerkeLevel2Sonderfaehigkeit.bedingung) and @@upgrades[upgradsInZahl()] >= Sonderfaehigkeit::ErhoehungsAnzahl
    ziel.teleportieren() if @upgrades.upgrade?(TeleportationSonderfaehigkeit.bedingung) and rand(0) < Sonderfaehigkeit::TeleportationsWkeit
    ziel.versteinern() if @upgrades.upgrade?(VersteinerungSonderfaehigkeit.bedingung) and rand(0) < Sonderfaehigkeit::VersteinerungsWkeit
    ziel.erkranken(schaden, self) if @upgrades.upgrade?(KrankheitSonderfaehigkeit.bedingung)
  end
  
  def prozentSchaden(typ)
    return 0 unless @upgrades.upgrade?(ProzentSchadenSondefaehigkeit.bedingung)
    typGrundSchaden(typ) / 10.0 * Sonderfaehigkeit::ProzentLP
  end

  def typGrundSchaden(typ)
    schaden = GrundSchaden
    schaden += Sonderfaehigkeit::ReichweiteLevel4StaerkeBoost * @@upgrades[upgradsInZahl()] if @upgrades.upgrade?(Reichweite4Sonderfaehigkeit.bedingung())
    effektivitaetsLevel = @upgrades.effektivitaetsLevel()
    if @upgrades.upgrades.length >= 1
      schaden += Sonderfaehigkeit::EffektivBoni[effektivitaetsLevel - 1] if effektiv?(@upgrades.typ, typ)
      schaden -= Sonderfaehigkeit::IneffektivMali[effektivitaetsLevel - 1] if ineffektiv?(@upgrades.typ, typ)
    end
    schaden
  end
  
  def berechneSchaden(typ, lp = 0)
    schaden = typGrundSchaden(typ)
    schaden *= Sonderfaehigkeit::KoenigsStaerkeBoost if @staerkeBoost
    schaden *= (1 + lp * Sonderfaehigkeit::ProzentLP / 1000) if @upgrades.upgrade?(ProzentSchadenSondefaehigkeit.bedingung)
    schaden *= Sonderfaehigkeit::StaerkeBoostLevel1 if @upgrades.upgrade?(StaerkeSonderfaehigkeit.bedingung)
    schaden *= Sonderfaehigkeit::StaerkeBoostLevel2 if @upgrades.upgrade?(StaerkeLevel2Sonderfaehigkeit.bedingung)
    schaden *= (1 + Sonderfaehigkeit::StaerkeWachsen * @welle) if @upgrades.upgrade?(StaerkeWachsenSonderfaehigkeit.bedingung)
    schaden *= (1 - Sonderfaehigkeit::SchnellLadenStaerkeMalusLevel2) if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung)
    schaden *= 1 + Math::log(@@maxVerursachterSchaden, 10) / 10.0 if @@maxVerursachterSchaden > 1
    if @upgrades.upgrade?(AllroundSonderfaehigkeit.bedingung())
      allroundFaktor = Sonderfaehigkeit::AllroundStaerkeBoost
      allroundFaktor = (Sonderfaehigkeit::AllroundStaerkeBoost - 1) * Sonderfaehigkeit::AllroundAnzahlBoost + 1 if @@upgrades[upgradsInZahl()] >= Sonderfaehigkeit::ErhoehungsAnzahl
      schaden *= Sonderfaehigkeit::AllroundStaerkeBoost 
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
    @upgrades.upgraden(typ)
    @welle = 0 if level() == 3
    if level() == 4
      @@upgrades[upgradsInZahl()] += 1
      @@reichweiteErhoehenAnzahlBonus = true if @upgrades.upgrade?(Reichweite3Sonderfaehigkeit.bedingung()) and @@upgrades[upgradsInZahl()] >= Sonderfaehigkeit::ErhoehungsAnzahl
      @@geschwindigkeitSteigernAnzahlBonus = true if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung) and @@upgrades[upgradsInZahl()] >= Sonderfaehigkeit::ErhoehungsAnzahl
    end
  end

  def downgraden()
    if level == 4
      @@upgrades[upgradsInZahl()] -= 1
      @@reichweiteErhoehenAnzahlBonus = testeAnzahlBonus(Reichweite3Sonderfaehigkeit.bedingung()) if @upgrades.upgrade?(Reichweite3Sonderfaehigkeit.bedingung()) and @@upgrades[upgradsInZahl()] == Sonderfaehigkeit::ErhoehungsAnzahl - 1
      @@geschwindigkeitSteigernAnzahlBonus = testeAnzahlBonus(SchnellLaden2Sondefaehigkeit.bedingung) if @upgrades.upgrade?(SchnellLaden2Sondefaehigkeit.bedingung) and @@upgrades[upgradsInZahl()] == Sonderfaehigkeit::ErhoehungsAnzahl - 1
    end
    @upgrades.downgraden()
  end

  def testeAnzahlBonus(array)
    array.permutation.to_a.any? {|permutation|
      testZahl = permutation.reduce(0) {|wert, upgrade| wert * 3 + UpgradeNummer[upgrade]}
      @@upgrades[testZahl] >= Sonderfaehigkeit::ErhoehungsAnzahl
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
