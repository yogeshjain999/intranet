class Notification
  include Mongoid::Document
  
  embedded_in :user

  field :notification_emails, type: String
end
