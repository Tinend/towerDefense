class Sonderfaehigkeit

  BonusLeben = 3
  LadenBoostLevel1 = 2
  LadenBoostLevel2 = 6
  SchnellLadenStaerkeMalusLevel2 = 0.4
  AllroundLadeBoost = 2
  AllroundStaerkeBoost = 1.3
  AllroundReichweiteBoost = 1
  EffektivBoni = [5, 22, 58, 35]
  IneffektivMali = [2, 4, 6, 8]
  StaerkeBoostLevel1 = 4.0 / 3
  StaerkeBoostLevel2 = 2.0
  StaerkeWachsen = 0.05
  ReichweiteBoostLevel1 = 1
  ReichweiteBoostLevel2 = 2
  ReichweiteBoostLevel3 = 3
  ReichweiteLevel4StaerkeBoost = 1
  DoppelWkeit = 0.5
  VereisungsWkeit = 0.015
  InstaDeathWkeit = 0.025
  TeleportationsWkeit = 0.03
  VersteinerungsWkeit = 0.0225
  ProzentLP = 2.0
  KoenigsReichweiteBoost = 1
  KoenigsGeschwindigkeitsBoost = 1
  KoenigsStaerkeBoost = 1.25
  ErhoehungsAnzahl = 3
  GeschwindigkeitsAnzahlBoost = 3
  ReichweiteAnzahlBoost = 1
  AllroundAnzahlBoost = 2

  GegnerMaxVerlangsamungsCounter = 30
  GegnerMaxVergiftungsCounter = 100
  GegnerMaxVereisungsCounter = 100
  GegnerStrahlFaktor = 30
  GegnerVerstrahlungsVerlangsamung = 0.97
  
  def initialize(bedingung, beschreibung, vordergrundFarbe, hintergrundFarbe, bild, hintergrundDurchsetzungsvermoegen, effekt)
    @bedingung = bedingung
    @beschreibung = beschreibung
    @vordergrundFarbe = vordergrundFarbe
    @hintergrundFarbe = hintergrundFarbe
    @bild = bild
    @hintergrundDurchsetzungsvermoegen = hintergrundDurchsetzungsvermoegen
    @effekt = effekt
  end

  def aussehenAn(x, y)
    [@vordergrundFarbe, @hintergrundFarbe, @bild[y][x], @effekt]
  end
  
  attr_reader :bedingung, :hintergrundDurchsetzungsvermoegen, :beschreibung

end
  
