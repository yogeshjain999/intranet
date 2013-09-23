class PublicProfile
  include Mongoid::Document
  include Mongoid::Paperclip
 
  field :first_name
  field :last_name
  field :gender
  field :mobile_number
  field :blood_group
  field :date_of_birth,       :type => Date

  has_mongoid_attached_file :attachment, :styles => { :large => "800x800", :medium => "400x400>", :small => "200x200>" }

  embedded_in :user
end
