class ChildSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :sex , :school_grade , :school_class
  belongs_to :parent
  belongs_to :school 
end