class PrivateProfile
  include Mongoid::Document
  
  field :pan_number
  field :passport_number
  field :qualification
  field :date_of_joining, :type => Date
  field :date_of_relieving, :type => Date
  field :work_experience
 
  embedded_in :user
  embeds_many :addresses
  embeds_many :relative_details
  #embeds_many :attachments 

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :relative_details
  #accepts_nested_attributes_for :attachments

  
  #validates_presence_of :pan_number, :on => :update

end
