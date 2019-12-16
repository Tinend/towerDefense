def zeileFuerZeile(string, laenge)
  woerter = string.split(" ")
  woerter.reduce([""]) do |anfang, wort|
    if anfang[-1].length + wort.length < laenge
      anfang[-1] += " " + wort
    else
      zeilenLaenge = wort.length + 1
      anfang.push(" " + wort)
    end
    anfang
  end
end
