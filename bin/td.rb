# coding: utf-8
require "curses"
include Curses
require 'colorize'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'FeldErsteller'
require 'Spielfeld'
require 'WegStueck'
require 'Feind'
require 'Baum'
require 'Feld'
require 'Menue'
require 'FeldFenster'
require 'BaumErsteller'
require 'GegnerArray'
require 'GegnerErsteller'
require 'StartMenue'
require 'Leiste'
require 'farben'
require 'NutzenAnzeiger'
require 'BaumUpgradeFensterBuilder'
require 'Spieler'

KEY_ENTER_REAL = 10
KEY_SLEERZEICHEN = 0
KEY_SUP = 337
KEY_SDOWN = 336

def change_pos(x, direction, min, max)
  x = (x + direction - min) % (max - min) + min
end

Curses.start_color
Curses.use_default_colors
farben()
BREITE = 30
HOEHENFAKTOR = 3
BREITENFAKTOR = 5
feldErsteller = FeldErsteller.new(BREITE)
baumUpgradeFensterBuilder = BaumUpgradeFensterBuilder.new()
nutzenAnzeiger = NutzenAnzeiger.new()
spielfeld = Spielfeld.new(feldErsteller.spielfeld, feldErsteller.start)

Freiraum = 4
init_screen
curs_set(0)
hoehe = spielfeld.hoehe * HOEHENFAKTOR
breite = spielfeld.breite * BREITENFAKTOR
baumErsteller = BaumErsteller.new()
spieler = Spieler.new()
gegnerErsteller = GegnerErsteller.new(spielfeld.start, spieler)
leiste = Leiste.new(Freiraum, breite, gegnerErsteller, spieler)
feldFenster = FeldFenster.new(Freiraum, 0, spielfeld, baumErsteller, {nutzenAnzeiger: nutzenAnzeiger, baumUpgradeFensterBuilder: baumUpgradeFensterBuilder}, leiste, spieler)
begin
  cbreak
  noecho
  crmode
  runde = 0
  setpos(0, 0)
  startMenue = StartMenue.new(["Einfach", "Mittel", "Schwierig", "Ultra"], hoehe, breite, Freiraum, 0, feldFenster, gegnerErsteller, baumErsteller, spieler)
  startMenue.auswaehlen()
  nutzenAnzeiger.erstelle(hoehe, breite, Freiraum, 0, feldFenster)
  baumUpgradeFensterBuilder.erstelle(hoehe, breite, Freiraum, 0, feldFenster)
  spielfeld.gegnerZahl = gegnerErsteller.anzahl
  gegnerArray = GegnerArray.new(nil, 0, 0, :pflanze, 1, spieler)
  #feldFenster.anfangsPhase
  #10.times {feldFenster.anfangsPhase}
  #50.times {feldFenster.aktivePhase()}
  until spieler.verloren?()
    runde += 1
    gegnerErsteller.definiereGegner()
    spieler.runde()
    feldFenster.aktivePhase()
    feldFenster.anzeigen()
    spielfeld.wellenBegin()
    gegnerArray = gegnerErsteller.erstelleGegner()
    zeitpunkt = 0
    leiste.inaktivieren(gegnerArray)
    begin
      leiste.inaktivOeffnen()
      feldFenster.anzeigen()
      until spieler.verloren?() or gegnerArray.gewonnen?()
        zeitpunkt += 1
        gegnerArray.bewegen()
        spielfeld.schiessen(gegnerArray)
        gegnerArray.sterben()
        gegnerArray.verletzen()
        feldFenster.kurzAnzeigen() if zeitpunkt % 3 == 0
        sleep(0.003)
      end
    ensure
      leiste.inaktivSchliessen()
    end
  end
ensure
  feldFenster.schliessen()
  Curses.close_screen()
end
puts "Du hast nach #{runde} Runden verloren!"
