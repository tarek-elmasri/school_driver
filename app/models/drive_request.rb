class DriveRequest < ApplicationRecord
  belongs_to :school
  belongs_to :parent
  has_many :children

  STATUS = [:pending, :acomplished , :canceled ]
  # TODO : add translation to messages and complete validations.
  validates :school_id , presence: true
  validates :parent_id , presence: true
  validates :status, presence:true , inclusion: STATUS
  validate :min_children_count


  def min_children_count
    errors.add(:children, I18n.t("child_required")) if children.size < 1
  end
end
