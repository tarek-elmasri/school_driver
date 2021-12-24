class School < ApplicationRecord
  has_many :children
  has_many :drive_requests

  scope :search, lambda { |params| 
    params ||= {}
    results = params[:margins] ? inMargin( params[:margins] ) : nil
  }

  def self.inMargin (margins)
    where(
      arel_table[:lat]
      .between(margins[:lat1]...margins[:lat2])
      .and(
        arel_table[:long]
        .between(margins[:long1]...margins[:long2])
      )
    )
  end
end
