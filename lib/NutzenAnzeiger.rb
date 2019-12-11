# coding: utf-8
require 'zeileFuerZeile'
require 'Spieler'
require 'farben'

class NutzenAnzeiger
  
  BeschreibungsBreite = 40
  FensterHoehe = 52
  BefehleBeschreibung = [
    "Pfeiltasten:Bewege ausgewähltes Feld; Mit Ctrl schneller",
    "Enter:Verteidiger bauen/upgraden",
    "' ':Diese Hilfe anzeigen",
    "Ctrl + ' ':Kaufphase beenden"
  ]
  
  def initialize()
  end
  
  def erstelle(hoehe, breite, verschiebungy, verschiebungx, elternFenster)
    @hoehe = hoehe
    @breite = breite
    @elternFenster = elternFenster
    @verschiebungy = verschiebungy
    @verschiebungx = verschiebungx
    @fensterBreite = BeschreibungsBreite * 3 + 19
    @fensterHoehe = FensterHoehe
    @wahl = 0
  end

  def erneuern()
    @elternFenster.erneuern()
    anzeigen()
  end
  
  def zeigeKombination(x, y, kombination)
    @fenster.setpos(y, x)
    kombination.each do |k|
      if k == :pflanze
        @fenster.attron(color_pair(berechneFarbe(Gruen, Gruen))|A_NORMAL) {
          @fenster.addstr(" ")
        }
      elsif k == :feuer
        @fenster.attron(color_pair(berechneFarbe(Rot, Rot))|A_NORMAL) {
          @fenster.addstr(" ")
        }
      elsif k == :wasser
        @fenster.attron(color_pair(berechneFarbe(Blau, Blau))|A_NORMAL) {
          @fenster.addstr(" ")
        }
      end
    end
  end

  def beschreibungBefehleAnzeigen(y)
    @fenster.setpos(y, 3)
    @fenster.addstr("Kontrollen:")
    y += 2
    BefehleBeschreibung.each do |bB|
      befehl, beschreibung = bB.split(":")
      @fenster.setpos(y, 3)
      @fenster.addstr(befehl + ": ")
      zeileFuerZeile(beschreibung, BeschreibungsBreite + 1 - befehl.length).each do |zeile|
        @fenster.setpos(y, 4 + befehl.length)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    y += 1
    return y
  end

  def kostenAnzeigen(y)
    @fenster.setpos(y, 3)
    @fenster.addstr("Preise:")
    y += 2
    @fenster.setpos(y, 3)
    @fenster.addstr("Turm bauen: #{Spieler::TurmKosten}")
    @fenster.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL){
      @fenster.addstr("$")
    }
    y += 2
    4.times do |i|
      @fenster.setpos(y, 3)
      @fenster.addstr("Turm auf Level #{i + 2} upgraden: #{Spieler::UpgradeKosten[i]}")
      @fenster.attron(color_pair(berechneFarbe(Gelb, Schwarz))|A_NORMAL){
        @fenster.addstr("$")
      }
      y += 2
    end
    y += 1
    return y
  end
  
  def anzeigen()
    @fenster.setpos(0,0)
    @fenster.addstr("/" + "-" * (@fensterBreite - 2) + "\\")
    y = 2
    y = beschreibungBefehleAnzeigen(y)
    y = kostenAnzeigen(y)
    Level1Sonderfaehigkeiten.each do |sf|
      zeigeKombination(3, y, sf.bedingung)
      zeileFuerZeile(sf.beschreibung, BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, 5)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    y += 1
    Level2Sonderfaehigkeiten.each do |sf|
      zeigeKombination(2, y, sf.bedingung)
      zeileFuerZeile(sf.beschreibung, BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, 5)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    y = 2
    Level3Sonderfaehigkeiten.each do |sf|
      zeigeKombination(BeschreibungsBreite + 8, y, sf.bedingung)
      zeileFuerZeile(sf.beschreibung, BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, BeschreibungsBreite + 12)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    y += 1
    x = BeschreibungsBreite + 7
    Level4Sonderfaehigkeiten.each do |sf|
      laenge = zeileFuerZeile(sf.beschreibung, BeschreibungsBreite).length
      if laenge + y >= @fensterHoehe
        x = 2 * BeschreibungsBreite + 13
        y = 2
      end
      zeigeKombination(x, y, sf.bedingung)
      zeileFuerZeile(sf.beschreibung, BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, x + 5)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    
    (@fensterHoehe - 2).times do |y|
      @fenster.setpos(y + 1, 0)
      @fenster.addstr("|")
      @fenster.setpos(y + 1, @fensterBreite - 1)
      @fenster.addstr("|")
    end
    @fenster.setpos(@fensterHoehe - 1, 0)
    @fenster.addstr("\\" + "-" * (@fensterBreite - 2) + "/")
  end
  
  def oeffnen()
    @wahl = 0
    @fenster = Window.new(@fensterHoehe, @fensterBreite, @verschiebungy + @hoehe / 2 - @fensterHoehe / 2, @verschiebungx + @breite / 2 - @fensterBreite / 2)
    @fenster.keypad = true
    erneuern()
  end

  def schliessen()
    @fenster.close()
    @elternFenster.erneuern()
  end

  def auswaehlen()
    @fenster.getch
  end

end
