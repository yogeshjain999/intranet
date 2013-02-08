class LeaveDetail
  include Mongoid::Document
  embedded_in :user
  belongs_to :organization
  field :assign_date, type: Date
  field :assign_leaves, type: Hash
  field :available_leaves, type: Hash
end
