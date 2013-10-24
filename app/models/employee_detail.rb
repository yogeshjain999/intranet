class EmployeeDetail
  include Mongoid::Document

  embedded_in :user

  field :employee_id, type: Integer
  field :notification_emails, type: Array

  before_save do 
    self.notification_emails.reject!(&:blank?)
  end
end
