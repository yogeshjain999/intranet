class ContactPerson
  include Mongoid::Document
  field :relation
  field :name
  field :phone_no

  embedded_in :private_profile
end
