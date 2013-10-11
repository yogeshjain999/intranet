class Attachment
  include Mongoid::Document
  mount_uploader :document, FileUploader 
  
  belongs_to :user

  field :name, type: String
  field :document, type: String
  #validates_presence_of :document, :name
end
