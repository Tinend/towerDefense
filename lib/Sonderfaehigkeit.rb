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
  
  attr_reader :bedingung, :hintergrundDurchsetzungsvermoegen

  def beschreibung(laenge)
    woerter = @beschreibung.split(" ")
    woerter.reduce([""]) do |anfang, wort|
      if anfang[-1].length + wort.length < laenge
        anfang[-1] += " " + wort
      else
        zeilenLaenge = wort.length + 1
        anfang.push(" " + wort)
      end
      anfang
    end
  end
end
  
