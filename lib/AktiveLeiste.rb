# coding: utf-8
require "curses"
include Curses
require 'colorize'
require 'farben'
require 'bilder/FeuerBild'
require 'bilder/WasserBild'
require 'bilder/PflanzenBild'
require 'Feind'

# Anzeige der Oberen Leiste, während der Spieler aktiv ist
class AktiveLeiste
  SchadenFaktorCyan = 1.4
  SchadenFaktorGruen = 1
  SchadenFaktorGelb = 0.9
  SchadenFaktorRot = 0.5

  
  def initialize(hoehe, breite, gegnerErsteller, spieler)
    @hoehe = hoehe
    @breite = breite
    @gegnerErsteller = gegnerErsteller
    @bauPhase = true
    @spieler = spieler
    @feuer = feuer
  end

  attr_accessor :bauPhase, :feuer
  
  def oeffnen(baumLevel)
    @baumLevel = baumLevel
    @window = Window.new(@hoehe, @breite, 0, 0)
  end

  def schliessen
    @window.close()
  end
                  
  def baumAnzeigen(baum, verschiebung)
    if baum != nil and baum.reichweite() > 0
      @window.setpos(0, verschiebung)
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("    A/\\    ")
      }
      @window.addstr(" ")
      @window.setpos(1, verschiebung)
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("\\  //  \\   ")
      }
      @window.addstr(" ")
      @window.setpos(2, verschiebung)
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("_\\")
      }
      @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
        @window.addstr(" O==== ~ ")
      }
      @window.addstr(" ")
      @window.setpos(3, verschiebung)
      @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
        @window.addstr("  ()-()")
      }
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("Y  Y")
      }     
      @window.addstr(" ")
      schussrate = baum.maxLaden().to_s
      @window.setpos(1, verschiebung + 12)
      @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
        @window.addstr("ZZ")
      }
      @window.addstr(":")
      @window.addstr(" " * (4 - schussrate.length) + schussrate)
      if baum.geschwindigkeitsBoost
        @window.setpos(1, verschiebung + 19)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(1, verschiebung + 19)
        @window.addstr(" ")
      end
      @window.setpos(2, verschiebung + 12)
      @window.addstr("->:")
      reichweite = [baum.reichweite(), 99.9].min.to_s
      @window.addstr(" " * (4 - reichweite.length) + reichweite)
      if baum.reichweiteBoost
        @window.setpos(2, verschiebung + 19)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(2, verschiebung + 19)
        @window.addstr(" ")
      end
      @window.setpos(0, verschiebung + 21)
      feuer = maxIntToString(baum.berechneSchaden(:feuer), 10**4)
      @window.addstr(" " * [(3 - feuer.length), 0].max)
      @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
        @window.addstr(feuer)
      }
      if baum.staerkeBoost
        @window.setpos(0, verschiebung + 24)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(0, verschiebung + 24)
        @window.addstr(" ")
      end
      @window.setpos(1, verschiebung + 21)
      pflanze = maxIntToString(baum.berechneSchaden(:pflanze), 10**4)
      @window.addstr(" " * [(3 - pflanze.length), 0].max)
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr(pflanze)
      }
      if baum.staerkeBoost
        @window.setpos(1, verschiebung + 24)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(1, verschiebung + 24)
        @window.addstr(" ")
      end
      @window.setpos(2, verschiebung + 21)
      wasser = maxIntToString(baum.berechneSchaden(:wasser), 10**4)
      @window.addstr(" " * [(3 - wasser.length), 0].max)
      @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
        @window.addstr(wasser)
      }
      if baum.staerkeBoost
        @window.setpos(2, verschiebung + 24)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(2, verschiebung + 24)
        @window.addstr(" ")
      end
      @window.setpos(3, verschiebung + 12)
      if baum.gesamtSchaden == 0
        string = " " * 12
      else
        schadenString = maxIntToString(baum.gesamtSchaden, 10**12)
        string = " " * (12 - schadenString.length) + schadenString
      end
      baum.level().times do |upgradeNummer|
        farbe = baum.upgradeFarbe(upgradeNummer)
        @window.attron(color_pair(berechneFarbe(Weiss, farbe))|A_NORMAL) {
          @window.addstr(string[upgradeNummer * 2 .. upgradeNummer * 2 + 1])
        }
      end
      @window.addstr(string[baum.level() * 2 .. 11])
    else
      4.times do |i|
        @window.setpos(i, verschiebung)
        @window.addstr(" " * 28)
      end
    end
  end

  def textBildUeberlagern(fenster, x, y, text, inBildX, inBildY, bild, farbe)
    fenster.setpos(y, x)
    text.length.times do |index|
      hintergrundFarbe = bild[inBildY][inBildX + index]
      if farbe != hintergrundFarbe
        fenster.attron(color_pair(berechneFarbe(farbe, hintergrundFarbe))) {
          fenster.addstr(text[index])
        }
      else
        fenster.attron(color_pair(berechneFarbe(Schwarz, hintergrundFarbe))) {
          fenster.addstr(text[index])
        }
      end
    end
  end
  
  def gegnerAnzeigen(verschiebung)
    gesamtLp = @gegnerErsteller.staerke * @gegnerErsteller.anzahl
    if @gegnerErsteller.typ() == :pflanze
      bild = PflanzenBild
      typFarbe = Weiss
      schriftFarbe = Schwarz
      typString = "Pflanze"
    elsif @gegnerErsteller.typ() == :feuer
      bild = FeuerBild
      typFarbe = Rot
      schriftFarbe = Schwarz
      typString = "Feuer"
    elsif @gegnerErsteller.typ() == :wasser
      bild = WasserBild
      typFarbe = Schwarz
      schriftFarbe = Weiss
      typString = "Wasser"
    end
    typString += " " * (7 - typString.length)
    textBildUeberlagern(@window, verschiebung, 0, "Typ vom Gegner:  ", 0, 0, bild, schriftFarbe)
    textBildUeberlagern(@window, verschiebung, 17, typString, 17, 0, bild, typFarbe)
    
    string = "Anzahl Gegner:   #{@gegnerErsteller.anzahl}"
    string += " " * (24 - string.length)
    textBildUeberlagern(@window, verschiebung, 1, string, 0, 1, bild, schriftFarbe)

    staerkeString = maxIntToString(@gegnerErsteller.staerke, 10**7)
    string = "Lebenspunkte:    " + staerkeString
    string += " " * (24 - string.length)
    textBildUeberlagern(@window, verschiebung, 2, string, 0, 2, bild, schriftFarbe)
    
    geschwindigkeit = (@gegnerErsteller.geschwindigkeit * 100 + 0.5).to_i / 100.0
    string = "Geschwindigkeit: #{geschwindigkeit}"
    string += " " * (24 - string.length)
    textBildUeberlagern(@window, verschiebung, 3, string, 0, 3, bild, schriftFarbe)
    
    @window.setpos(2, 30 + verschiebung)
    @window.addstr("Summe der Lebenspunkte der Gegner:")
    @window.setpos(3, 30 + verschiebung)
    @window.addstr(gesamtLp.to_s + "   ")
    @baumLevel.each_with_index do |bl, i|
      @window.setpos(3, 4 * i + 70 + verschiebung)
      @window.addstr(bl.to_s)
    end
  end

  def maxIntToString(int, max)
    if int >= max
      ziffern = Math::log(int, 10).to_i
      signifikanteStellen = (int / (10 ** (ziffern - 1))).to_i / 10.0
      return signifikanteStellen.to_s + "e+" + ziffern.to_s
    else
      return int.to_s
    end
  end
  
  def phaseAnzeigen(verschiebung)
    text = "Bauphase"
    3.times do |i|
      @window.setpos(i, verschiebung)
      @window.addstr(" " * 21)
    end
    @window.setpos(0, verschiebung + (13 - text.length) / 2)
    @window.addstr("+" + "-" * text.length + "+")
    @window.setpos(1, verschiebung + (13 - text.length) / 2)
    @window.addstr("|" + text + "|")
    @window.setpos(2, verschiebung + (13 - text.length) / 2)
    @window.addstr("+" + "-" * text.length + "+")
  end

  def lebenAnzeigen(verschiebung)
    herz = @spieler.herz()
    herz.each_with_index do |zeile, y|
      zeile.length.times do |x|
        @window.setpos(y, x + verschiebung)
        if zeile[x] == "#"
          @window.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
            @window.addstr(" ")
          }
        elsif zeile[x] != " "
          @window.attron(color_pair(berechneFarbe(Gelb, Rot))|A_NORMAL) {
            @window.addstr(zeile[x])
          }
        end
      end
    end
  end

  def geldAnzeigen(verschiebung)
    @window.setpos(1, verschiebung)
    gold = @spieler.gold.to_s
    @window.addstr(" " * (5 - gold.length) + gold)
    @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
      @window.addstr("$")
    }
  end

  def feuerAnzeigen(verschiebung)
    @window.setpos(0, verschiebung + 1)
    @window.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
      @window.addstr(" ")
    }
    @window.setpos(1, verschiebung)
    @window.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
      @window.addstr("   ")
    }
    @window.setpos(2, verschiebung)
    @window.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
      @window.addstr("   ")
    }
    @window.setpos(2, verschiebung + 1)
    @window.attron(color_pair(berechneFarbe(Gelb, Gelb))|A_NORMAL) {
      @window.addstr(" ")
    }
    @window.setpos(3, verschiebung + 1)
    @window.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
      @window.addstr(" ")
    }
    @window.setpos(2, verschiebung + 4)
    @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
      @window.addstr(@feuer.to_s)
    }
    if @feuer >= Sonderfaehigkeit::GegnerVerbrennFaktor
      @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
        @window.addstr(" (" + (@feuer / Sonderfaehigkeit::GegnerVerbrennFaktor).to_s + ")")
      }
    else
      @window.addstr("     ")
    end
    @window.addstr("     ")
  end

  def siegAnzeigen(verschiebung)
    Siegesbedingungen.each_with_index do |s, i|
      @window.setpos(i, verschiebung)
      @window.addstr(((s.fortschritt * 10).to_i / 10.0).to_s + "%")
    end
  end
  
  def anzeigen(baum)
    lebenAnzeigen(2)
    phaseAnzeigen(10)
    #phaseAnzeigen(3)
    geldAnzeigen(23)
    baumAnzeigen(baum, 30)
    if @feuer > 0
      feuerAnzeigen(30)
    end
    gegnerAnzeigen(57)
    siegAnzeigen(140)
    @window.refresh()
  end

end
