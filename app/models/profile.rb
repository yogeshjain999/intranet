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
  field :phone_number, type: Integer
  field :dateOfBirth, type: Date
  field :passport_number, type: String
  validates :name, :local_address, :permanent_address,    :dateOfBirth, :phone_number, :presence => true
  validates :phone_number, :length => { :is => 10 }, :allow_blank => true 
  validates :pan_number, :length => { :is => 10 }, :allow_blank => true 
  validates :pan_number, :format => { :with => /\A[A-Z]{5}\d{4}[A-Z]{1}\Z/ , :message => 'invalid pan number'}, :allow_blank => true 
  validate :birth_date_validation

    def valid_date(date)
regexp = /\d{2}\/\d{2}\/\d{4}/
date = date.to_s
    if date.include?("/")
      arr_date = date.split("/")
    elsif date.include?("-")
            arr_date = date.split("-")
    end
    if regexp.match(date) != nil
      if arr_date != nil && arr_date.length == 3
        if Date.valid_date?(arr_date[2].to_i, arr_date[1].to_i, arr_date[0].to_i)
          return true
        end
      end
    end
    return false
  end

  def birth_date_validation        
    if dateOfBirth != "" || dateOfBirth != nil
      if valid_date(dateOfBirth) != true
        errors.add(:dateOfBirth, "Invalid date of birth")
      elsif dateOfBirth >= Date.today
        errors.add(:dateOfBirth, "Do not allow to enter future date.")      
      elsif dateOfBirth.year > Date.today.year - 18
        errors.add(:dateOfBirth, "Please enter the 18 year before date.")
      end
    end
  end
end
