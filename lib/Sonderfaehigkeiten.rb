# coding: utf-8
require 'Sonderfaehigkeit'
require 'farben'

FeuerSonderfaehigkeit = Sonderfaehigkeit.new([:feuer], "+5 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister", Rot, Cyan, ["     ", "  M  ", "     "], false)
WasserSonderfaehigkeit = Sonderfaehigkeit.new([:wasser], "+5 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Blau, Cyan, ["     ", "  U  ", "     "], false)
PflanzeSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze], "+5 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Gruen, Cyan, ["     ", "  Y  ", "     "], false)
Level1Sonderfaehigkeiten = [FeuerSonderfaehigkeit, WasserSonderfaehigkeit, PflanzeSonderfaehigkeit]

Feuer2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer], "+5 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister an", Rot, Cyan, ["     ", " A A ", "     "], false)
Wasser2Sonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser], "+5 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Blau, Cyan, ["     ", " ~ ~ ", "     "], false)
Pflanze2Sonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze], "+5 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Gruen, Cyan, ["     ", " ( ) ", "     "], false)
ReichweiteSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser], "+1 Reichweite", Magenta, Cyan, ["     ", " > < ", "     "], false)
SchnellLadenSondefaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze], "-2 Schussrate", Gelb, Cyan, ["     ", " Z Z ", "     "], false)
StaerkeSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser], "+40% Schaden", Schwarz, Cyan, ["     ", " X X ", "     "], false)
Level2Sonderfaehigkeiten = [Feuer2Sonderfaehigkeit, Wasser2Sonderfaehigkeit, Pflanze2Sonderfaehigkeit, ReichweiteSonderfaehigkeit, SchnellLadenSondefaehigkeit, StaerkeSonderfaehigkeit]

Feuer3Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer], "+5 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister an", Gelb, Cyan, ["  A  ", "     ", "  A  "], false)
Wasser3Sonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser, :wasser], "+5 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Weiss, Blau, ["  ~  ", "     ", "  ~  "], true)
Pflanze3Sonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze], "+5 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Rot, Gruen, ["  O  ", "     ", "  A  "], true)
SchwaechenStaerkerSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :wasser], "Vervierfacht Schwächen und Stärken der Geister", Schwarz, Cyan, ["  T  ", "     ", "  U  "], false)
SplashSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser, :wasser], "Trifft alle Gegner auf einem Feld. Zielt auf Felder mit möglichst vielen Gegnern", Magenta, Gruen, ["  @  ", "     ", "  @  "], false)
VergiftungsSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze], "Vergiftet Gegner zeitweise und verdoppelt dadurch den Schaden insgesamt. Versucht Unvergiftete zu treffen.", Gruen, Blau, ["  :  ", "     ", "  :  "], true)
VerlangsamungsSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :wasser], "Halbiert Geschwindigkeit von Gegnern zeitweise. Versucht unverlangsamte Ziele zu treffen.", Weiss, Cyan, ["  #  ", "     ", "  #  "], false)
VereisungsSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser, :wasser], "Lässt Gegner mit einer W'keit von 1% hundert Züge lang einfrieren. Versucht uneingefrorene Ziele zu treffen", Weiss, Cyan, ["  *  ", "  M  ", "  *  "], false)
DoppelterSchadenSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze], "Verursacht 50% sicher doppelten Schaden", Rot, Cyan, ["  X  ", "     ", "  X  "], false)
Reichweite2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :wasser], "+2 Reichweite", Gelb, Gruen, ["  V  ", "     ", "  A  "], false)
Level3Sonderfaehigkeiten = [Feuer3Sonderfaehigkeit, Wasser3Sonderfaehigkeit, Pflanze3Sonderfaehigkeit, SchwaechenStaerkerSonderfaehigkeit, SplashSonderfaehigkeit, VergiftungsSonderfaehigkeit, VerlangsamungsSonderfaehigkeit, VereisungsSonderfaehigkeit, DoppelterSchadenSonderfaehigkeit, Reichweite2Sonderfaehigkeit]

InstaDeathSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :feuer], "1% Chance auf Insta-Death", Gelb, Rot, ["/\\ /\\", "     ", "/\\ /\\"], true)
BrandSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :pflanze], "Erzündet dauerhaft ein Feuer auf dem Zielfeld, das jedem Gegner dort jede Runde 20% sicher ein Leben nimmt", Rot, Cyan, ["ÜÄ  V", "     ", ".ö oÖ"], false)
Reichweite4Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :wasser], "+4 Reichweite", Gruen, Cyan, ["\\\\ //", "     ", "// \\\\"], false)
ProzentSchadenSondefaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze, :pflanze],  "Grundschaden entspricht mindestens 10% der gegnerischen Lebenspunkte. Attackiert bevorzugt stärkere Gegner", Gelb, Cyan, ["   %%", "     ", "%%   "], false)
SchnellLaden2Sondefaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze, :wasser], "-5 Schussrate, halbiert Schaden", Gelb, Cyan, ["ZZ ZZ", "     ", "ZZ ZZ"], false)
HeilungsSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :wasser, :wasser], "Heilt dich. (Noch nicht implementiert)", Rot, Cyan, ["/\\ /\\", "\   /", " \\_/  "], false)
KrankheitSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze, :pflanze], "Macht Getroffenen dauerhaft krank. Dieser verliert 10% der Leben die dieser Treffer ausmacht pro Runde. Vermeidet Schiessen auf Kranke, wenn möglich", Weiss, Schwarz, ["     ", "     ", "_ö__L"], true)
Staerke2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze, :wasser], "Doppelter Schaden", Schwarz, Cyan, ["XX XX", "     ", "YW WY"], false)
Reichweite3Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :wasser, :wasser], "+3 Reichweite", Magenta, Cyan, ["\\\\ //", "     ", "// \\\\"], false)
ReichweiteKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser, :wasser, :wasser], "+1 Reichweite für alle Verteidiger in Reichweite, außer andere Verstärker. Dieser Turm schießt nicht.", Rot, Blau, ["|    ", "|    ", "L____"], true)
VersteinerungSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze, :pflanze], "1% Chance auf Versteinerung", Weiss, Cyan, ["OO OO", "     ", "OO OO"], true)
StaerkeKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze, :wasser], "+10% Schaden für alle Verteidiger in Reichweite. Dieser Turm schießt nicht.", Gelb, Cyan, ["|\\M/|", "|   |", "|   |"], false)
AllroundSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :wasser, :wasser], "+1 Reichweite; -1 Schussrate, +20% Schaden", Schwarz, Cyan, ["__ ==", "     ", "== __"], false)
SchnellLadenKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser, :wasser, :wasser], "-1 Schussrate für alle Verteidiger in Reichweite. Dieser Turm schießt nicht.", Gelb, Cyan, ["|\\ /|", "| V |", "|   |"], false)
TeleportationSonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser, :wasser, :wasser], "1% Chance den Gegner an den Anfang zurückzuteleportieren", Magenta, Cyan, ["/---\\", "|« »|", "\\---/"], false)
Level4Sonderfaehigkeiten = [InstaDeathSonderfaehigkeit, BrandSonderfaehigkeit, Reichweite4Sonderfaehigkeit, ProzentSchadenSondefaehigkeit, SchnellLaden2Sondefaehigkeit, HeilungsSonderfaehigkeit, KrankheitSonderfaehigkeit, Staerke2Sonderfaehigkeit, Reichweite3Sonderfaehigkeit, ReichweiteKoenigSonderfaehigkeit, VersteinerungSonderfaehigkeit, StaerkeKoenigSonderfaehigkeit, AllroundSonderfaehigkeit, SchnellLadenKoenigSonderfaehigkeit, TeleportationSonderfaehigkeit]
