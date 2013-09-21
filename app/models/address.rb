class Address
  include Mongoid::Document
  field :type_of_address,          :type => String
  field :flat_or_house_no,         :type => String
  field :building_or_society_name, :type => String
  field :road,                     :type => String
  field :locality,                 :type => String
  field :city,                     :type => String
  field :state,                    :type => String
  field :phone_no,                 :type => String
  #field :address_proof,           :type => String
end
