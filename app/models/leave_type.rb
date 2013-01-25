class LeaveType
  include Mongoid::Document
  belongs_to :organization
  field :name, type: String
  field :max_no_of_leaves, type: Integer
  field :auto_increament, type: Boolean
  field :number_of_leaves, type: Integer
  field :carry_forward, type: Boolean 
  validates :name, :max_no_of_leaves, presence: true
  validates :max_no_of_leaves, :numericality => { :greater_than => 0 } 

  def as_json(option = {})
    option = { :only => [:id, :name, :max_no_of_leaves, :auto_increament, :number_of_leaves, :carry_forward]} if option.nil?
      super
  end
end
