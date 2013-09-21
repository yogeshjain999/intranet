class PublicProfile
  include Mongoid::Document
 
  field :first_name,          :type => String
  field :last_name,           :type => String
  field :gender,              :type => String
  field :mobile_number,       :type => String
  field :blood_group,         :type => String
  field :date_of_birth,       :type => Date
  #field :photo,               :type => String
  embedded_in :user
end
