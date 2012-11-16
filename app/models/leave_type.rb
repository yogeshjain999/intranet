class LeaveType
  include Mongoid::Document

  field :name
  field :max_no_of_leaves, type: Integer
end
