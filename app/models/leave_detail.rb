class LeaveDetail
  include Mongoid::Document
  embedded_in :user
  has_many :leave_types

  field :assignedDate, type: Date
  field :availableLeaves, type: Integer
  field :finishedLeaves, type: Integer
end
