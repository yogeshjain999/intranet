
class Profile
  include Mongoid::Document
  field :name, type: String
  field :local_address, type: String
  field :permanent_address, type: String
  field :pan_number, type: String
  field :github_handle, type: String
  field :twitter_handle, type: String
  field :phone_number, type: String
  field :dateOfBirth, type: Date
  field :join_date, type: Date
  field :employee_id, type: Integer
  field :passport_number, type: String
  validates :pan_number, :length => { :is => 10 }, :allow_blank => true 

  validates :pan_number, :format => { :with => /\A[A-Z]{5}\d{4}[A-Z]{1}\Z/ , :message => 'invalid pan number'}, :allow_blank => true 




#belongs_to :user
end
