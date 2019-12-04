# coding: utf-8
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'GegnerSortierer'
require 'ordnung/MultiOrdnung'

class Gegner
  def initialize(laufDistanz, position)
    @laufDistanz = laufDistanz
    @position = position
  end

  attr_reader :laufDistanz, :position
end

class GegnerArray
  def initialize(gegnerArray)
    @gegner = gegnerArray
  end

  attr_reader :gegner
end

array = [
  Gegner.new(1, [0, 0]),
  Gegner.new(2, [0, 0]),
  Gegner.new(0, [1, 0]),
  Gegner.new(3, [2, 0]),
  Gegner.new(5, [4, 0])
]

gegnerArray = GegnerArray.new(array)
gegnerSortierer = GegnerSortierer.new(MultiOrdnung)
ziele = gegnerSortierer.multiZielFinden([0, 0], 3, gegnerArray)
p ziele
