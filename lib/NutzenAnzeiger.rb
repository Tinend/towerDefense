class NutzenAnzeiger
  
  BeschreibungsBreite = 40
  
  def initialize()
  end
  
  def erstelle(hoehe, breite, verschiebungy, verschiebungx, elternFenster)
    @hoehe = hoehe
    @breite = breite
    @elternFenster = elternFenster
    @verschiebungy = verschiebungy
    @verschiebungx = verschiebungx
    @fensterBreite = BeschreibungsBreite * 3 + 22
    @fensterHoehe = 52
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

  def anzeigen()
    @fenster.setpos(0,0)
    @fenster.addstr("/" + "-" * (@fensterBreite - 2) + "\\")
    y = 2
    Level1Sonderfaehigkeiten.each do |sf|
      zeigeKombination(3, y, sf.bedingung)
      sf.beschreibung(BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, 5)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    y += 3
    Level2Sonderfaehigkeiten.each do |sf|
      zeigeKombination(2, y, sf.bedingung)
      sf.beschreibung(BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, 5)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    y = 2
    Level3Sonderfaehigkeiten.each do |sf|
      zeigeKombination(BeschreibungsBreite + 7, y, sf.bedingung)
      sf.beschreibung(BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, BeschreibungsBreite + 11)
        @fenster.addstr(zeile)
        y += 1
      end
      y += 1
    end
    y = 2
    Level4Sonderfaehigkeiten.each do |sf|
      zeigeKombination(2 * BeschreibungsBreite + 13, y, sf.bedingung)
      sf.beschreibung(BeschreibungsBreite).each do |zeile|
        @fenster.setpos(y, 2 * BeschreibungsBreite + 18)
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
