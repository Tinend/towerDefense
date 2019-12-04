raise
require 'colorize'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'FeldErsteller'
require 'Spielfeld'
require 'WegStueck'
require 'Feind'
require 'Baum'
require 'Feld'

breite = 150
feldErsteller = FeldErsteller.new(breite)
spielfeld = Spielfeld.new(feldErsteller.spielfeld, feldErsteller.start)
puts spielfeld.anzeigen()
