class ContactPerson
  include Mongoid::Document
  field :relation
  field :name
  field :phone_no

  embedded_in :private_profile
  
  validates :phone_no, length: { is: 10 }, numericality: { only_integer: true }, allow_blank: true
end
