class ChildSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender , :school_grade , :school_class , :dob
  belongs_to :parent
  belongs_to :school 


end