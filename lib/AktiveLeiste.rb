# coding: utf-8
require "curses"
include Curses
require 'colorize'
require 'farben'

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
  end

  def oeffnen(baumLevel)
    @gruenSchaden = (@gegnerErsteller.anzahl * 2 + 2) * 10
    @baumLevel = baumLevel
    @window = Window.new(@hoehe, @breite, 0, 0)
  end

  def schliessen
    @window.close()
  end

  def schadensFarbe(minSchaden, maxSchaden, reichweite)
    gewichtung = 0.98 ** (reichweite ** 2)
    wert = minSchaden * (1 - gewichtung) + maxSchaden * gewichtung
    if wert > @gruenSchaden * SchadenFaktorCyan
      return berechneFarbe(Cyan, Schwarz)
    elsif wert > @gruenSchaden * SchadenFaktorGruen
      return berechneFarbe(Gruen, Schwarz)
    elsif wert > @gruenSchaden * SchadenFaktorGelb
      return berechneFarbe(Gelb, Schwarz)
    elsif wert > @gruenSchaden * SchadenFaktorRot
      return berechneFarbe(Rot, Schwarz)
    else
      return berechneFarbe(Magenta, Schwarz)
    end
  end
    
  def anzeigen(baum, treffer)
    gesamtLp = @gegnerErsteller.staerke * @gegnerErsteller.anzahl
    minTreffer, maxTreffer = treffer
    @window.setpos(0, 0)
    @window.addstr("Typ vom Gegner:  ")
    zeigeTyp()
    @window.addstr("   ")
    @window.setpos(1, 0)
    @window.addstr("Anzahl Gegner:   #{@gegnerErsteller.anzahl}   ")
    @window.setpos(2, 0)
    @window.addstr("Lebenspunkte:    #{@gegnerErsteller.staerke}   ")
    @window.setpos(3, 0)
    @window.addstr("Geschwindigkeit: #{@gegnerErsteller.geschwindigkeit}   ")
    @window.setpos(2, 38)
    @window.addstr("Summe der Lebenspunkte der Gegner:")
    @window.setpos(3,38)
    @window.addstr(gesamtLp.to_s + "   ")
    @baumLevel.each_with_index do |bl, i|
      @window.setpos(3,80 + 4 * i)
      @window.addstr(bl.to_s)
    end
    @window.refresh()
  end

  def zeigeTyp()
    if @gegnerErsteller.typ() == :pflanze
      @window.attron(color_pair(berechneFarbe(Gruen, Schwarz))|A_NORMAL) {
        @window.addstr("Pflanze")
      }
    elsif @gegnerErsteller.typ() == :feuer
      @window.attron(color_pair(berechneFarbe(Rot, Schwarz))|A_NORMAL) {
        @window.addstr("Feuer")
      }
    elsif @gegnerErsteller.typ() == :wasser
      @window.attron(color_pair(berechneFarbe(Blau, Schwarz))|A_NORMAL) {
        @window.addstr("Wasser")
      }
    end
  end
end
