class School < ApplicationRecord
  has_many :children
  has_many :drive_requests

  scope :search, lambda { |params| 
    params ||= {}
    results = where(nil)
    results = results.inMargin( params["margins"] ) unless params["margins"].blank?
    results = results.nameLike(params["name"]) unless params["name"].blank?
    return results
  }

  def self.inMargin (margins)
    where(
      arel_table[:lat]
      .between(margins["lat1"]...margins["lat2"])
      .and(
        arel_table[:long]
        .between(margins["long1"]...margins["long2"])
      )
    )
  end

  def self.nameLike name
    where(
      arel_table[:a_name]
      .matches("%#{name}%")
      .or(
        arel_table[:e_name]
        .matches("%#{name}%")
      )
    )
  end
end
