class Locations::Location

  attr_reader :lat, :long

  def initialize(coords={})
    if coords.kind_of?(String)
      struct_string(coords)
    else
      struct_hash(coords)
    end
  end

  def to_s
    return nil unless valid?
    "#{lat} #{long}"
  end

  def coords
    return nil unless valid?
    {:lat => lat , :long => long}
  end

  def valid?
    return false if lat.blank? || long.blank?
    return false if lat == 0.0 || long == 0.0
    true
  end

  private 
  attr_writer :lat , :long

  def struct_string content
    self.lat = content.split(" ")[0].to_f
    self.long = content.split(" ")[1].to_f
  end

  def struct_hash content
    self.lat = content[:lat].to_f
    self.long = content[:long].to_f
  end
end