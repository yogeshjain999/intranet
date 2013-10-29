class Address
  include Mongoid::Document
  field :type_of_address
  field :flat_or_house_no
  field :building_or_society_name
  field :locality
  field :city
  field :state
  field :phone_no
  field :same_as_permanent_address, type: Boolean, default: false
  field :pin_code

  belongs_to :private_profile
  belongs_to :leave_application
  
  validates :phone_no, length: { is: 10 }, numericality: { only_integer: true }, allow_blank: true
end
