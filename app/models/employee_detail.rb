class EmployeeDetail
  include Mongoid::Document

  embedded_in :user

  field :employee_id, type: Integer
  field :notification_emails, type: String
end
