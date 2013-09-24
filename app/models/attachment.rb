class Attachment
  include Mongoid::Document
=begin
  include Mongoid::Paperclip

  has_mongoid_attached_file :attachment, styles: {thumbnail: "60x60#"}
  validates_attachment :attachment, content_type: { content_type: "application/pdf" }
  
  embedded_in :private_profile
=end
end
