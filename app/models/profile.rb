class Profile
  include Mongoid::Document
  embedded_in :user

  attr_accessible :name, :local_address, :permanent_address, :pan_number, :github_handle, :linkedin_name, :twitter_handle, :phone_number, :dateOfBirth,   :passport_number
  field :name, type: String
  field :local_address, type: String
  field :permanent_address, type: String
  field :pan_number, type: String
  field :github_handle, type: String
  field :twitter_handle, type: String
  field :linkedin_name, type: String
  field :phone_number, type: String
  field :dateOfBirth, type: Date

  field :passport_number, type: String
  #validates :pan_number, :length => { :is => 10 }, :allow_blank => true 
  validates :name, :local_address, :permanent_address,    :dateOfBirth, :pan_number, :phone_number, :presence => true
    validates :phone_number, :length => { :is => 10 }, :allow_blank => true 
  validates :pan_number, :format => { :with => /\A[A-Z]{5}\d{4}[A-Z]{1}\Z/ , :message => 'invalid pan number'}, :allow_blank => true 
  end
