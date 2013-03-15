class LeaveType
  include Mongoid::Document
  belongs_to :organization
  field :name, type: String
  field :max_no_of_leaves, type: Float
  field :auto_increament, type: Boolean
  field :number_of_leaves, type: Float 
  field :can_apply, type: Float
  field :carry_forward, type: Boolean 
  validates :name, :max_no_of_leaves, presence: true
  validates :number_of_leaves, :presence => true, :if => :require_validation? 
  validates  :max_no_of_leaves, :numericality => { :greater_than => 0}
  validates :number_of_leaves, :can_apply, :numericality => { :greater_than => 0}, :allow_blank => true 
  validates :number_of_leaves, :can_apply,  :numericality => { :less_than_or_equal_to => :max_no_of_leaves}, :allow_blank => true 


  def require_validation?
    auto_increament == true
  end


  def as_json(option = {})
    option = { :only => [:id, :name, :max_no_of_leaves, :auto_increament, :number_of_leaves, :carry_forward]} if option.nil?
      super
  end
end
