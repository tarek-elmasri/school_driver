class Locations::Location

  attr_accessor :lat, :long

  def initialize lat,long
    self.lat = lat
    self.long = long
  end

  def merged_cords
    #return nil if lat.blank? || long.blank?
    return "#{lat} #{long}"
  end

end