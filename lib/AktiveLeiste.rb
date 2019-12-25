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

  SchadenBreite = 4
  
  def initialize(hoehe, breite, gegnerErsteller, spieler)
    @hoehe = hoehe
    @breite = breite
    @gegnerErsteller = gegnerErsteller
    @bauPhase = true
    @spieler = spieler
    @radioaktivitaet = radioaktivitaet
  end

  attr_accessor :bauPhase, :radioaktivitaet
  
  def oeffnen(baumLevel)
    @baumLevel = baumLevel
    @window = Window.new(@hoehe, @breite, 0, 0)
  end

  def schliessen
    @window.close()
  end

  def baumBildAnzeigen(baum, verschiebung)
    if baum.level == 0
      baumLevel0Anzeigen(verschiebung)
    elsif baum.level == 1
      baumLevel1Anzeigen(verschiebung)
    elsif baum.level == 2
      baumLevel2Anzeigen(verschiebung)
    elsif baum.level == 3
      baumLevel3Anzeigen(verschiebung)
    elsif baum.level == 4
      baumLevel4Anzeigen(verschiebung)
    else
      raise
    end
  end

  def baumLevel0Anzeigen(verschiebung)
    @window.setpos(0, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("    𐘠/\\    ")
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
      @window.addstr(" o———")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("¯")
    }   
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("~  ")
    }
    @window.addstr(" ")
    @window.setpos(3, verschiebung)
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("  ()()")
    }
    @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
      @window.addstr("|")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾 🌾 ")
    }     
    @window.addstr(" ")
  end
  
  def baumLevel1Anzeigen(verschiebung)
    @window.setpos(0, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("    𐘠/\\    ")
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
      @window.addstr(" O———— ~ ")
    }
    @window.addstr(" ")
    @window.setpos(3, verschiebung)
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("  ()—()")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾 🌾 ")
    }     
    @window.addstr(" ")
  end
  
  def baumLevel2Anzeigen(verschiebung)
    @window.setpos(0, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("    𐘠/\\    ")
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
      @window.addstr(" O===== ~")
    }
    @window.addstr(" ")
    @window.setpos(3, verschiebung)
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("  ()——()")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr(" 🌾 ")
    }     
    @window.addstr(" ")
  end
  
  def baumLevel3Anzeigen(verschiebung)
    @window.setpos(0, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("    𐘠/\\    ")
    }
    @window.addstr(" ")
    @window.setpos(1, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("\\ ")
    }
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("ߍ__")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      #@window.addstr("/")
    }   
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("___")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      #@window.addstr("\\")
    }   
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("_ ~")
    }
    @window.setpos(2, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("_\\")
    }
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("V——————~ ")
    }
    @window.addstr(" ")
    @window.setpos(3, verschiebung)
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("  ()——()")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr(" 🌾 ")
    }     
    @window.addstr(" ")
  end
  
  def baumLevel4Anzeigen(verschiebung)
    @window.setpos(0, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("    𐘠/\\    ")
    }
    @window.addstr(" ")
    @window.setpos(1, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("\\ ")
    }
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("𐘠————————")
    }
    @window.setpos(2, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("_\\")
    }
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("V————————")
    }
    @window.addstr(" ")
    @window.setpos(3, verschiebung)
    @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
      @window.addstr("  ()———()")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾 ")
    }     
    @window.addstr(" ")
  end

  def wegBildAnzeigen(verschiebung)#Krokodil: 🐊
    @window.setpos(0, verschiebung)#◥█◤◣◢
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr(" 🌾 ")
    }    
    @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
      @window.addstr("◢█◣ ")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾 🌾 ")
    }    
    @window.addstr(" ")
    @window.setpos(1, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾 ")
    }    
    @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
      @window.addstr("◢███◣ ")
    }   
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾  ")
    }    
    @window.addstr(" ")
    @window.setpos(2, verschiebung)
    @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
      @window.addstr(" ◢█")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Blau))|A_NORMAL) {
      @window.addstr("🐊  ")
    }    
    @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
      @window.addstr("█◣")
    }   
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾  ")
    }    
    @window.addstr(" ")
    @window.setpos(3, verschiebung)
    @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
      @window.addstr("◢███████◣  ")
    }   
    @window.addstr(" ")
  end
  
  def feldBildAnzeigen(baum, verschiebung)
    if baum != nil and baum.reichweite() > 0
      baumBildAnzeigen(baum, verschiebung)
    elsif baum == nil
      wegBildAnzeigen(verschiebung)
    elsif baum.reichweite == 0
      leeresFeldAnzeigen(verschiebung)
    else
      4.times do |i|
        @window.setpos(i, verschiebung)
        @window.addstr(" " * 12)
      end
    end
  end

  def leeresFeldAnzeigen(verschiebung)
    @window.setpos(0, verschiebung)
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("    𐘠/\\    ")
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
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("/_=")
    }
    @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
      @window.addstr("||")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("¯   ")
    }   
    @window.addstr(" ")
    @window.setpos(3, verschiebung)
    @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
      @window.addstr("𐂂")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("   ")
    }
    @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
      @window.addstr("᰼||")
    }
    @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
      @window.addstr("🌾 🌾 ")
    }     
    @window.addstr(" ")
  end
                  
  def baumAnzeigen(baum, verschiebung)
    if baum != nil and baum.reichweite() > 0
      schussrate = baum.maxLaden().to_s
      @window.setpos(1, verschiebung)
      @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
        @window.addstr("⚡")
      }
      @window.addstr(":")
      @window.addstr(" " * (5 - schussrate.length) + schussrate)
      if baum.geschwindigkeitsBoost
        @window.setpos(1, verschiebung + 7)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(1, verschiebung + 7)
        @window.addstr(" ")
      end
      @window.setpos(2, verschiebung)
      @window.addstr("—>:")
      reichweite = [baum.reichweite(), 99.9].min.to_s
      @window.addstr(" " * (4 - reichweite.length) + reichweite)
      if baum.reichweiteBoost
        @window.setpos(2, verschiebung + 7)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(2, verschiebung + 7)
        @window.addstr(" ")
      end
      @window.addstr(" ")
      @window.setpos(0, verschiebung + 9)
      feuer = maxIntToString(baum.berechneSchaden(:feuer), 10**4)
      @window.addstr(" " * [(SchadenBreite - feuer.length), 0].max)
      @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
        @window.addstr(feuer)
      }
      if baum.staerkeBoost
        @window.setpos(0, verschiebung + 13)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(0, verschiebung + 13)
        @window.addstr(" ")
      end
      @window.setpos(1, verschiebung + 9)
      pflanze = maxIntToString(baum.berechneSchaden(:pflanze), 10**4)
      @window.addstr(" " * [(SchadenBreite - pflanze.length), 0].max)
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr(pflanze)
      }
      if baum.staerkeBoost
        @window.setpos(1, verschiebung + 13)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(1, verschiebung + 13)
        @window.addstr(" ")
      end
      @window.setpos(2, verschiebung + 9)
      wasser = maxIntToString(baum.berechneSchaden(:wasser), 10**4)
      @window.addstr(" " * [(SchadenBreite - wasser.length), 0].max)
      @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
        @window.addstr(wasser)
      }
      if baum.staerkeBoost
        @window.setpos(2, verschiebung + 13)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      else
        @window.setpos(2, verschiebung + 13)
        @window.addstr(" ")
      end
      @window.setpos(3, verschiebung)
      if baum.gesamtSchaden == 0
        string = " " * 13
      else
        schadenString = maxIntToString(baum.gesamtSchaden, 10**12)
        string = " " * (13 - schadenString.length) + schadenString
      end
      baum.level().times do |upgradeNummer|
        farbe = baum.upgradeFarbe(upgradeNummer)
        @window.attron(color_pair(berechneFarbe(Weiss, farbe))|A_NORMAL) {
          @window.addstr(string[upgradeNummer * 2 .. upgradeNummer * 2 + 1])
        }
      end
      @window.addstr(string[baum.level() * 2 .. 12])
    else
      4.times do |i|
        @window.setpos(i, verschiebung)
        @window.addstr(" " * 17)
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
    @window.addstr("+" + "—" * text.length + "+")
    @window.setpos(1, verschiebung + (13 - text.length) / 2)
    @window.addstr("|" + text + "|")
    @window.setpos(2, verschiebung + (13 - text.length) / 2)
    @window.addstr("+" + "—" * text.length + "+")
  end

  def lebenAnzeigen(verschiebung)
    lpString = @spieler.leben.to_s
    lpString = " " * [5 - lpString.length, 0].max + lpString[0..4]
    @window.setpos(1, verschiebung)
    @window.addstr(lpString)
    @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
      @window.addstr("")
    }    
  end

  def geldAnzeigen(verschiebung)
    @window.setpos(2, verschiebung)
    gold = @spieler.gold.to_s
    @window.addstr(" " * (5 - gold.length) + gold)
    @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
      @window.addstr("$")
    }
  end
  
  def radioaktivitaetAnzeigen(verschiebung)#Feuer: 🔥
    if @radioaktivitaet > 0 # Radioaktivität: ☢
      @window.setpos(2, verschiebung)
      @window.addstr(" " * (7 - [@radioaktivitaet, 9999999].min.to_s.length))
      @window.addstr([@radioaktivitaet, 9999999].min.to_s + " ")
      if @radioaktivitaet >= Sonderfaehigkeit::GegnerStrahlFaktor
        @window.addstr("(" + (@radioaktivitaet / Sonderfaehigkeit::GegnerStrahlFaktor).to_s)
        @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
          @window.addstr("")
        }
        @window.addstr(") ")
      end
      @window.attron(color_pair(berechneFarbe(Schwarz, Gelb))|A_NORMAL) {
        @window.addstr("☢ ")
      }
      if @radioaktivitaet < Sonderfaehigkeit::GegnerStrahlFaktor
        @window.addstr("     ")
      end
      @window.addstr("     ")
    end
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
    geldAnzeigen(2)
    feldBildAnzeigen(baum, 23)
    baumAnzeigen(baum, 35)
    radioaktivitaetAnzeigen(35)
    gegnerAnzeigen(51)
    siegAnzeigen(134)
    @window.refresh()
  end

end
