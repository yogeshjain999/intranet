class LeaveType
  include Mongoid::Document

  field :name, type: String
  field :max_no_of_leaves, type: Integer
  field :number_of_leaves, type: Integer
  validates :name, :max_no_of_leaves, presence: true
  validates :max_no_of_leaves, :numericality => { :greater_than => 0 } 

  belongs_to :leave
end
