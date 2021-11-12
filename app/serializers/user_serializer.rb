class UserSerializer < ActiveModel::Serializer
  attributes :id, :email , :phone_no, :type
  has_one :parent, if: -> { object.is_parent? }
  has_one :driver, if: -> { object.is_driver? }


  def type 
    (object.is_parent?) ? :parent : :driver
  end
end
