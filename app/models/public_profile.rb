class PublicProfile
  include Mongoid::Document
  include Mongoid::Paperclip
 
  field :first_name
  field :last_name
  field :gender
  field :mobile_number
  field :blood_group
  field :date_of_birth, :type => Date

  has_mongoid_attached_file :photo, :styles => { :thumb => "100x100#" }, 
                                    :path => ":rails_root/public/system/photo/:id/:style/:filename",
                                    :url => "/system/photo/:id/:style/:filename",    
                                    :default_url => "/system/default_photo.gif"

  #validates_attachment :photo, :content_type => { :content_type => "image/jpg" }

  embedded_in :user
end
