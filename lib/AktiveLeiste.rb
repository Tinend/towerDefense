# coding: utf-8
require "curses"
include Curses
require 'colorize'
require 'farben'
require 'bilder/FeuerBild'
require 'bilder/WasserBild'
require 'bilder/PflanzenBild'

# Anzeige der Oberen Leiste, während der Spieler aktiv ist
class AktiveLeiste
  SchadenFaktorCyan = 1.4
  SchadenFaktorGruen = 1
  SchadenFaktorGelb = 0.9
  SchadenFaktorRot = 0.5

  
  def initialize(hoehe, breite, gegnerErsteller)
    @hoehe = hoehe
    @breite = breite
    @gegnerErsteller = gegnerErsteller
    @bauPhase = true
  end

  attr_accessor :bauPhase
  
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
      @window.setpos(1, verschiebung)
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("\\  //  \\   ")
      }
      @window.setpos(2, verschiebung)
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("_\\")
      }
      @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
        @window.addstr(" O==== ~ ")
      }
      @window.setpos(3, verschiebung)
      @window.attron(color_pair(berechneFarbe(Weiss, Schwarz))|A_NORMAL) {
        @window.addstr("  ()-()")
      }
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("Y  Y")
      }     
      schussrate = baum.maxLaden().to_s
      @window.setpos(1, verschiebung + 12)
      @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
        @window.addstr("ZZ")
      }
      @window.addstr(":")
      @window.addstr(" " * (4 - schussrate.length) + schussrate)
      if baum.geschwindigkeitsBoost
        @window.setpos(1, verschiebung + 18)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      end
      @window.setpos(2, verschiebung + 12)
      @window.addstr("->:")
      reichweite = baum.reichweite().to_s
      @window.addstr(" " * (4 - reichweite.length) + reichweite)
      if baum.reichweiteBoost
        @window.setpos(2, verschiebung + 18)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      end
      @window.setpos(1, verschiebung + 21)
      feuer = baum.berechneSchaden(:feuer).to_s
      @window.addstr(" " * (4 - feuer.length))
      @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
        @window.addstr(feuer)
      }
      if baum.staerkeBoost
        @window.setpos(1, verschiebung + 26)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      end
      @window.setpos(0, verschiebung + 21)
      pflanze = baum.berechneSchaden(:pflanze).to_s
      @window.addstr(" " * (4 - pflanze.length))
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr(pflanze)
      }
      if baum.staerkeBoost
        @window.setpos(0, verschiebung + 26)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      end
      @window.setpos(2, verschiebung + 21)
      wasser = baum.berechneSchaden(:wasser).to_s
      @window.addstr(" " * (4 - wasser.length))
      @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
        @window.addstr(wasser)
      }
      if baum.staerkeBoost
        @window.setpos(2, verschiebung + 26)
        @window.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL) {
          @window.addstr("+")
        }
      end
      @window.setpos(3, verschiebung + 12)
      baum.level().times do |upgradeNummer|
        farbe = baum.upgradeFarbe(upgradeNummer)
        @window.attron(color_pair(berechneFarbe(farbe, farbe))|A_NORMAL) {
          @window.addstr("  ")
        }
      end
      @window.addstr(" " * 2 * (4 - baum.level()))
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
    
    string = "Lebenspunkte:    #{@gegnerErsteller.staerke}"
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
      @window.setpos(3, 4 * i + 80 + verschiebung)
      @window.addstr(bl.to_s)
    end
  end

  def phaseAnzeigen(verschiebung)
    if bauPhase
      text = "Bauphase"
    else
      text = "Upgradephase"
    end
    3.times do |i|
      @window.setpos(i, verschiebung)
      @window.addstr(" " * 25)
    end
    @window.setpos(0, verschiebung + (18 - text.length) / 2)
    @window.addstr("+" + "-" * text.length + "+")
    @window.setpos(1, verschiebung + (18 - text.length) / 2)
    @window.addstr("|" + text + "|")
    @window.setpos(2, verschiebung + (18 - text.length) / 2)
    @window.addstr("+" + "-" * text.length + "+")
  end
  
  def anzeigen(baum)
    phaseAnzeigen(3)
    baumAnzeigen(baum, 25)
    gegnerAnzeigen(52)
    @window.refresh()
  end

end
