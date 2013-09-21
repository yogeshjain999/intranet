class PrivateProfile
  include Mongoid::Document
  
  field :date_of_birth,            :type => Date
  field :wife_name,                :type => String
  field :wife_phone_no,            :type => String
  field :father_name,              :type => String
  field :father_phone_no,          :type => String
  field :mother_name,              :type => String
  field :mother_phone_no,          :type => String
  field :pan_number,               :type => String
  field :passport_number,          :type => String
  field :qualification,            :type => String
  field :date_of_joining,          :type => Date
  field :date_of_relieving,        :type => Date
  field :work_experience,          :type => String
  
  embeds_many :addresses

end
