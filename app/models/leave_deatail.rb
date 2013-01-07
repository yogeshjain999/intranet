class LeaveDeatail
  include Mongoid::Document
  belongs_to :user
  belongs_to :leave_type

  field :assignedDate, type: Date
  field :remainLeaves, type: Integer
  field :finishedLeaves, type: Integer

end
