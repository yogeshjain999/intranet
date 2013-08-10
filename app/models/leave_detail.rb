class LeaveDetail
  include Mongoid::Document
  embedded_in :user
  field :assign_date, type: Date
  field :assign_leaves, type: Hash
  field :available_leaves, type: Hash
  field :unpaid_leave, type: Hash
end
