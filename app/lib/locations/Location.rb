class Location

  attr_accessor :lat, :long

  def initialize location
    self.lat = location[:lat]
    self.long = location[:long]
  end

  def merged_cords
    "#{lat} #{long}"
  end

end