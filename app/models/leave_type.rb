class LeaveType
  include Mongoid::Document
    
  field :leave_type,          type: String
  field :number_of_days,      type: Float
  field :can_carry_forward,   type: Boolean

  LEAVE_TYPE = ['Sick', 'Casual', 'Paid']
end
