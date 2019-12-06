class Spieler
  MaxLeben = 20
  def initialize()
    @leben = MaxLeben
  end

  attr_accessor :leben

  def verloren?()
    @leben <= 0
  end

  def verleztWerden()
    @leben -= 1
  end

  def heilen()
    @leben += 1
  end

  def herz()
    mittelZeile = "#" * (4 - (@leben.to_s.length + 1) / 2) + @leben.to_s + "#" * (3 - @leben.to_s.length / 2)
    [
      " ## ## ",
      mittelZeile,
      " ##### ",
      "   #   "
    ]
  end
end
