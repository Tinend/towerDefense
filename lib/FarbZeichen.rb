class FarbZeichen
  def initialize(vordergrundFarbe, hintergrundFarbe, zeichen)
    @vordergrundFarbe = vordergrundFarbe
    @hintergrundFarbe = hintergrundFarbe
    @zeichen = zeichen
  end

  attr_reader :vordergrundFarbe, :hintergrundFarbe, :zeichen
end
