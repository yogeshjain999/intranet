class PrivateProfile
  include Mongoid::Document
  
  field :pan_number
  field :personal_emailid
  field :passport_number
  field :qualification
  field :date_of_joining, :type => Date
  field :date_of_relieving, :type => Date
  field :work_experience
  field :previous_company

  embedded_in :user
  embeds_many :addresses
  embeds_many :contact_persons
  #embeds_many :attachments 

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :contact_persons
  #accepts_nested_attributes_for :attachments

  
  validates_presence_of :qualification, :date_of_joining, :personal_emailid, :on => :update

end
