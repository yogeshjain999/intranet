class LeaveDetail
  include Mongoid::Document
  embedded_in :user

  field :leave_types, type: Hash
  field :available_leaves, type: Hash
end
