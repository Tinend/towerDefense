class FarbZeichen
  def initialize(vordergrundFarbe, hintergrundFarbe, zeichen, effekt)
    @vordergrundFarbe = vordergrundFarbe
    @hintergrundFarbe = hintergrundFarbe
    @zeichen = zeichen
    @effekt = effekt
  end

  attr_reader :vordergrundFarbe, :hintergrundFarbe, :zeichen, :effekt
end
