class LeaveDetail
  include Mongoid::Document

  belongs_to :user
  
  field :year,            type: Integer
  field :used_leaves,     type: Hash
end
