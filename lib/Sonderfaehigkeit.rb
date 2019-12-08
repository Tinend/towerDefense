class Sonderfaehigkeit
  def initialize(bedingung, beschreibung, vordergrundFarbe, hintergrundFarbe, bild, hintergrundDurchsetzungsvermoegen)
    @bedingung = bedingung
    @beschreibung = beschreibung
    @vordergrundFarbe = vordergrundFarbe
    @hintergrundFarbe = hintergrundFarbe
    @bild = bild
    @hintergrundDurchsetzungsvermoegen = hintergrundDurchsetzungsvermoegen
  end

  def aussehenAn(x, y)
    [@vordergrundFarbe, @hintergrundFarbe, @bild[y][x]]
  end
  
  attr_reader :bedingung, :hintergrundDurchsetzungsvermoegen, :beschreibung

end
  
