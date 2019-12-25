# coding: utf-8
require 'Sonderfaehigkeit'
require 'farben'
require 'Feind'

FeuerSonderfaehigkeit = Sonderfaehigkeit.new([:feuer], "+5 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister", Rot, Cyan, ["     ", "  🔥. ", "     "], false, A_NORMAL)
PflanzeSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze], "+5 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Gruen, Cyan, ["     ", "  🌱. ", "     "], false, A_DIM)
WasserSonderfaehigkeit = Sonderfaehigkeit.new([:wasser], "+5 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Blau, Cyan, ["     ", "  🌊  ", "     "], false, A_DIM)
Level1Sonderfaehigkeiten = [FeuerSonderfaehigkeit, PflanzeSonderfaehigkeit, WasserSonderfaehigkeit]

Feuer2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer], "+17 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister an", Rot, Gelb, ["     ", "🔥..🔥.", "     "], false, A_NORMAL)
SchnellLadenSondefaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze], "-2 Schussrate", Gelb, Cyan, ["     ", " ⚡   ", "     "], false, A_NORMAL)
ReichweiteSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser], "+1 Reichweite", Magenta, Cyan, ["     ", "→. ←.", "     "], false, A_NORMAL)
Pflanze2Sonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze], "+17 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Rot, Weiss, ["  🍎. ", "     ", "     "], true, A_NORMAL)
StaerkeSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser], "+33% Schaden", Schwarz, Cyan, ["     ", " X X ", "     "], false, A_NORMAL)
Wasser2Sonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser], "+17 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Blau, Cyan, ["     ", "∿∿ ∿∿", "     "], false, A_NORMAL)
Level2Sonderfaehigkeiten = [Feuer2Sonderfaehigkeit, SchnellLadenSondefaehigkeit, ReichweiteSonderfaehigkeit, Pflanze2Sonderfaehigkeit, StaerkeSonderfaehigkeit, Wasser2Sonderfaehigkeit]

Feuer3Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer], "+36 Schaden gegen Pflanzengeister; -2 Schaden gegen Wassergeister an", Gelb, Rot, ["     ", "🔥.O🔥.", "     "], true, A_NORMAL)
DoppelterSchadenSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze], "Verursacht 50% sicher doppelten Schaden", Rot, Cyan, ["  ↟  ", "     ", "  ↡  "], false, A_NORMAL)
Reichweite2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :wasser], "+2 Reichweite", Gelb, Gruen, ["  V  ", "     ", "  𐘠  "], false, A_NORMAL)
VergiftungsSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze], "Vergiftet Gegner 100 Runden lang und verdoppelt dadurch den Schaden insgesamt. Versucht Unvergiftete zu treffen.", Gruen, Cyan, ["     ", "     ", "    "], false, A_DIM)
StaerkeWachsenSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :wasser], "Wird jede Runde 5% stärker (linear)", Gelb, Cyan, ["  💡. ", "     ", "     "], false, A_NORMAL)
SplashSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser, :wasser], "Trifft alle Gegner auf einem Feld. Zielt auf Felder mit möglichst vielen Gegnern", Schwarz, Cyan, ["  💥. ", "     ", "  💥. "], false, A_NORMAL)
Pflanze3Sonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze], "+36 Schaden gegen Wassergeister; -2 Schaden gegen Feuergeister an", Gruen, Weiss, ["     ", "🍏. 🍏.", "     "], true, A_NORMAL)
VerlangsamungsSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :wasser], "Halbiert Geschwindigkeit von Gegnern 30 Runden lang. Versucht unverlangsamte Ziele zu treffen.", Weiss, Cyan, ["     ", "     ", "  🕸.  "], false, A_NORMAL)
VereisungsSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser, :wasser], "Lässt Gegner mit einer W'keit von 1.5% hundert Runden lang einfrieren. Versucht uneingefrorene Ziele zu treffen", Weiss, Cyan, ["    ", "     ", "    "], true, A_NORMAL)
Wasser3Sonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser, :wasser], "+36 Schaden gegen Feuergeister; -2 Schaden gegen Pflanzengeister an", Blau, Cyan, ["  ∿  ", "     ", "  ∿  "], false, A_NORMAL)
Level3Sonderfaehigkeiten = [Feuer3Sonderfaehigkeit, DoppelterSchadenSonderfaehigkeit, Reichweite2Sonderfaehigkeit, VergiftungsSonderfaehigkeit, StaerkeWachsenSonderfaehigkeit, SplashSonderfaehigkeit, Pflanze3Sonderfaehigkeit, VerlangsamungsSonderfaehigkeit, VereisungsSonderfaehigkeit, Wasser3Sonderfaehigkeit]

InstaDeathSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :feuer], "2.5% Chance auf Insta-Death", Gelb, Rot, ["🔥. 🔥.", "     ", "🔥. 🔥."], true, A_NORMAL)
BrandSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :pflanze], "Verstrahlt das Zielfeld dauerhaft. #{Sonderfaehigkeit::GegnerStrahlFaktor} Radioaktivitaet verursachen bei jedem Feind, der das Feld betritt 1 Lp Schaden. Gegner die durch die Strahlung verletzt werden, werden dauerhaft 3% langsamer.", Schwarz, Gelb, ["     ", "     ", "☢. ☢."], false, A_NORMAL)
Reichweite4Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :feuer, :wasser], "+x Reichweite, +10x% Staerke, -x/10 Schussrate, wobei x die Anzahl der Türmen mit identischen Upgrades ist", Gruen, Cyan, ["\\\\ //", "     ", "// \\\\"], false, A_BOLD)
ProzentSchadenSondefaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze, :pflanze],  "Gegnerische Leben * 0.3% mehr Schaden. Attackiert bevorzugt stärkere Gegner", Gelb, Cyan, ["   %%", "     ", "%%   "], false, A_NORMAL)
SchnellLaden2Sondefaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :pflanze, :wasser], "-6 Schussrate, 40% weniger Schaden; -3 Schussrate für alle Verteidiger, bei 3 Türmen mit identischen Upgrades", Gelb, Cyan, ["⚡⚡ ⚡⚡", "     ", "⚡⚡ ⚡⚡"], false, A_NORMAL)
HeilungsSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :feuer, :wasser, :wasser], "Heilt dich um 1 Lebenspunkt, wenn ein Baum mit dieser Fähigkeit einen Gegner besiegt. Wenn dieser Upgrade gemacht wird, bekommst du 3 Lebenspunkte", Rot, Cyan, ["/\\ /\\", "\\   /", " \\_/  "], false, A_NORMAL)
KrankheitSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze, :pflanze], "Macht Getroffenen dauerhaft krank. Dieser verliert SCHADEN*(0.1+LPMAX/100'000) Leben pro Runde. SCHADEN ist der Schaden vom Schuss und LPMAX die Maximalleben des Feindes. Vermeidet Schiessen auf Kranke, wenn möglich", Weiss, Schwarz, ["     ", "     ", "☣. ☣."], true, A_NORMAL)
StaerkeLevel2Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :pflanze, :wasser], "*2 Schaden; Wenn es mindestens #{Sonderfaehigkeit::ErhoehungsAnzahl} Türme gibt, erhöht sich der Schaden von allen Türmen um 10*log10(x)%, wobei x der maximale Schaden ist, den einer dieser Türme verursacht hat", Schwarz, Cyan, ["XX XX", "     ", "YW WY"], false, A_NORMAL)
Reichweite3Sonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :pflanze, :wasser, :wasser], "+3 Reichweite; +1 Reichweite für alle Verteidiger, bei 3 Türmen mit identischen Upgrades", Magenta, Cyan, ["\\\\ //", "     ", "// \\\\"], false, A_BOLD)
ReichweiteKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:feuer, :wasser, :wasser, :wasser], "+1 Reichweite für alle Verteidiger in Reichweite", Gelb, Cyan, ["👑.   ", "     ", " ⟶.. "], false, A_NORMAL)
VersteinerungSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze, :pflanze], "2.25% Chance auf Versteinerung", Schwarz, Cyan, ["⛰..⛰.", "     ", "⛰. ⛰."], true, A_BOLD)
StaerkeKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :pflanze, :wasser], "+25% Schaden für alle Verteidiger in Reichweite", Gelb, Cyan, ["|\\M/|", "|   |", "|   |"], false, A_NORMAL)
AllroundSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :pflanze, :wasser, :wasser], "+1 Reichweite; -2 Schussrate, +30% Schaden; Verdoppelt sich, wenn es 3 identische Türme gibt", Schwarz, Cyan, ["__ ==", "     ", "== __"], false, A_NORMAL)
SchnellLadenKoenigSonderfaehigkeit = Sonderfaehigkeit.new([:pflanze, :wasser, :wasser, :wasser], "-1 Schussrate für alle Verteidiger in Reichweite", Gelb, Cyan, ["|\\ /|", "| V |", "|   |"], false, A_NORMAL)
TeleportationSonderfaehigkeit = Sonderfaehigkeit.new([:wasser, :wasser, :wasser, :wasser], "3% Chance den Gegner an den Anfang zurückzuteleportieren", Magenta, Cyan, ["./——\\", ".|꥟.|", ".\\——/"], false, A_NORMAL)
Level4Sonderfaehigkeiten = [InstaDeathSonderfaehigkeit, BrandSonderfaehigkeit, Reichweite4Sonderfaehigkeit, ProzentSchadenSondefaehigkeit, SchnellLaden2Sondefaehigkeit, HeilungsSonderfaehigkeit, KrankheitSonderfaehigkeit, StaerkeLevel2Sonderfaehigkeit, Reichweite3Sonderfaehigkeit, ReichweiteKoenigSonderfaehigkeit, VersteinerungSonderfaehigkeit, StaerkeKoenigSonderfaehigkeit, AllroundSonderfaehigkeit, SchnellLadenKoenigSonderfaehigkeit, TeleportationSonderfaehigkeit]
