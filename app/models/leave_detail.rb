class LeaveDetail
  include Mongoid::Document
  embedded_in :user
  belongs_to :leave_type
  belongs_to :profiles

  field :assignedDate, type: Date
  field :availableLeaves, type: Integer
  field :finishedLeaves, type: Integer
end
