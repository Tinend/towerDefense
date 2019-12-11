# coding: utf-8
require 'Sonderfaehigkeit'
require 'farben'

FeuerSonderfaehigkeit = Sonderfaehigkeit.new([:feuer], "+5 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister", Rot, Cyan, ["     ", "  M  ", "     "], false)
PflanzeSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze], "+5 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Gruen, Cyan, ["     ", "  Y  ", "     "], false)
WasserSonderfaehigkeit = Sonderfaehigkeit.new([:wasser], "+5 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Blau, Cyan, ["     ", "  U  ", "     "], false)
Level1Sonderfaehigkeiten = [FeuerSonderfaehigkeit, PflanzeSonderfaehigkeit, WasserSonderfaehigkeit]

Feuer2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer], "+17 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister an", Rot, Cyan, ["     ", " A A ", "     "], false)
SchnellLadenSondefaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze], "-2 Schussrate", Gelb, Cyan, ["     ", " Z Z ", "     "], false)
ReichweiteSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser], "+1 Reichweite", Magenta, Cyan, ["     ", " > < ", "     "], false)
Pflanze2Sonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze], "+17 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Gruen, Cyan, ["     ", " ( ) ", "     "], false)
StaerkeSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser], "+33% Schaden", Schwarz, Cyan, ["     ", " X X ", "     "], false)
Wasser2Sonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser], "+17 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Blau, Cyan, ["     ", " ~ ~ ", "     "], false)
Level2Sonderfaehigkeiten = [Feuer2Sonderfaehigkeit, SchnellLadenSondefaehigkeit, ReichweiteSonderfaehigkeit, Pflanze2Sonderfaehigkeit, StaerkeSonderfaehigkeit, Wasser2Sonderfaehigkeit]

Feuer3Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer], "+36 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister an", Gelb, Cyan, ["  A  ", "     ", "  A  "], false)
DoppelterSchadenSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze], "Verursacht 50% sicher doppelten Schaden", Rot, Cyan, ["  X  ", "     ", "  X  "], false)
Reichweite2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :wasser], "+2 Reichweite", Gelb, Gruen, ["  V  ", "     ", "  A  "], false)
VergiftungsSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze], "Vergiftet Gegner 100 Runden lang und verdoppelt dadurch den Schaden insgesamt. Versucht Unvergiftete zu treffen.", Gruen, Blau, ["  :  ", "     ", "  :  "], true)
SchwaechenStaerkerSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :wasser], "+30 Schaden gegen Geister, gegen welche dieser Turm effektiv ist; -6 Schaden gegen Geister mit Resistenzen gegen diesen Turm", Schwarz, Cyan, ["  T  ", "     ", "  U  "], false)
SplashSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser, :wasser], "Trifft alle Gegner auf einem Feld. Zielt auf Felder mit möglichst vielen Gegnern", Magenta, Gruen, ["  @  ", "     ", "  @  "], false)
Pflanze3Sonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze], "+36 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Rot, Gruen, ["  O  ", "     ", "  A  "], true)
VerlangsamungsSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :wasser], "Halbiert Geschwindigkeit von Gegnern 30 Runden lang. Versucht unverlangsamte Ziele zu treffen.", Weiss, Cyan, ["  #  ", "     ", "  #  "], false)
VereisungsSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser, :wasser], "Lässt Gegner mit einer W'keit von 1.5% hundert Runden lang einfrieren. Versucht uneingefrorene Ziele zu treffen", Weiss, Cyan, ["  *  ", "  M  ", "  *  "], true)
Wasser3Sonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser, :wasser], "+36 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Weiss, Blau, ["  ~  ", "     ", "  ~  "], true)
Level3Sonderfaehigkeiten = [Feuer3Sonderfaehigkeit, DoppelterSchadenSonderfaehigkeit, Reichweite2Sonderfaehigkeit, VergiftungsSonderfaehigkeit, SchwaechenStaerkerSonderfaehigkeit, SplashSonderfaehigkeit, Pflanze3Sonderfaehigkeit, VerlangsamungsSonderfaehigkeit, VereisungsSonderfaehigkeit, Wasser3Sonderfaehigkeit]

InstaDeathSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :feuer], "2.5% Chance auf Insta-Death", Gelb, Rot, ["/\\ /\\", "     ", "/\\ /\\"], true)
BrandSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :pflanze], "Erzündet dauerhaft ein Feuer auf dem Zielfeld, das jedem Gegner dort jede Runde 60% sicher ein Leben nimmt", Rot, Cyan, ["     ", "     ", "ÜÜ ÜÜ"], false)
Reichweite4Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :wasser], "+x Reichweite, wobei x die Anzahl der Türmen mit identischen Upgrades ist", Gruen, Cyan, ["\\\\ //", "     ", "// \\\\"], false)
ProzentSchadenSondefaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze, :pflanze],  "Gegnerische Leben * 0.3% mehr Schaden. Attackiert bevorzugt stärkere Gegner", Gelb, Cyan, ["   %%", "     ", "%%   "], false)
SchnellLaden2Sondefaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze, :wasser], "-6 Schussrate, 40% weniger Schaden; -3 Schussrate für alle Verteidiger, bei 3 Türmen mit identischen Upgrades", Gelb, Cyan, ["ZZ ZZ", "     ", "ZZ ZZ"], false)
HeilungsSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :wasser, :wasser], "Heilt dich um 1 Lebenspunkt, wenn ein Baum mit dieser Fähigkeit einen Gegner besiegt. Wenn dieser Upgrade gemacht wird, bekommst du 3 Lebenspunkte", Rot, Cyan, ["/\\ /\\", "\\   /", " \\_/  "], false)
KrankheitSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze, :pflanze], "Macht Getroffenen dauerhaft krank. Dieser verliert SCHADEN*(0.1+LPMAX/100'000) Leben pro Runde. SCHADEN ist der Schaden vom Schuss und LPMAX die Maximalleben des Feindes. Vermeidet Schiessen auf Kranke, wenn möglich", Weiss, Schwarz, ["     ", "     ", "_ö__L"], true)
StaerkeWachsenSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze, :wasser], "Schaden wird auf 10x% gesetzt, wobei x die Anzahl an Runden ist, die dieser Turm vollständig geupgradet ist", Schwarz, Cyan, ["XX XX", "     ", "YW WY"], false)
Reichweite3Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :wasser, :wasser], "+3 Reichweite; +1 Reichweite für alle Verteidiger, bei 3 Türmen mit identischen Upgrades", Magenta, Cyan, ["\\\\ //", "     ", "// \\\\"], false)
ReichweiteKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser, :wasser, :wasser], "+1 Reichweite für alle Verteidiger in Reichweite", Rot, Blau, ["|    ", "|    ", "L____"], true)
VersteinerungSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze, :pflanze], "2.5% Chance auf Versteinerung", Weiss, Cyan, ["OO OO", "     ", "OO OO"], true)
StaerkeKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze, :wasser], "+25% Schaden für alle Verteidiger in Reichweite", Gelb, Cyan, ["|\\M/|", "|   |", "|   |"], false)
AllroundSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :wasser, :wasser], "+1 Reichweite; -2 Schussrate, +30% Schaden; Verdoppelt sich, wenn es 3 identische Türme gibt", Schwarz, Cyan, ["__ ==", "     ", "== __"], false)
SchnellLadenKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser, :wasser, :wasser], "-1 Schussrate für alle Verteidiger in Reichweite", Gelb, Cyan, ["|\\ /|", "| V |", "|   |"], false)
TeleportationSonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser, :wasser, :wasser], "3% Chance den Gegner an den Anfang zurückzuteleportieren", Magenta, Cyan, ["/---\\", "|« »|", "\\---/"], false)
Level4Sonderfaehigkeiten = [InstaDeathSonderfaehigkeit, BrandSonderfaehigkeit, Reichweite4Sonderfaehigkeit, ProzentSchadenSondefaehigkeit, SchnellLaden2Sondefaehigkeit, HeilungsSonderfaehigkeit, KrankheitSonderfaehigkeit, StaerkeWachsenSonderfaehigkeit, Reichweite3Sonderfaehigkeit, ReichweiteKoenigSonderfaehigkeit, VersteinerungSonderfaehigkeit, StaerkeKoenigSonderfaehigkeit, AllroundSonderfaehigkeit, SchnellLadenKoenigSonderfaehigkeit, TeleportationSonderfaehigkeit]
