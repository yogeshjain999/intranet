class RelativeDetail
  include Mongoid::Document
  
  field :relative
  field :name
  field :phone_no

  embedded_in :private_profile
end
