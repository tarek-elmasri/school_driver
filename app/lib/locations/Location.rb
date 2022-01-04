class Locations::Location

  attr_reader :lat, :long

  def initialize(data={})
    set_coords data
  end
  
  def set_coords(data)
    if data.kind_of?(String)
      struct_string(data)
    elsif data.kind_of?(Hash)
      struct_hash(data)
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
    self.lat = content.split(" ").first.to_f
    self.long = content.split(" ").last.to_f
  end

  def struct_hash content
    self.lat = content[:lat].to_f
    self.long = content[:long].to_f
  end
end