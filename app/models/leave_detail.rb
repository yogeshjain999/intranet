class LeaveDetail
  include Mongoid::Document
  belongs_to :user
  
  field :year,            type: Integer
  field :available_leave,     type: Hash, default: {"Sick" => 0, "Casual" => 0, "Paid" => 0}

  
  def monthly_paid_leave
    if (self.user.private_profile.date_of_joining.month == (Date.today.month-1) && self.user.private_profile.date_of_joining <= 15) || (self.user.private_profile.date_of_joining.month != (Date.today.month-1))
      self.available_leave["Paid"] += 1.5
    end
    self 
  end
  
  def validate_leave(name, number_of_day)
    ((self.available_leave[name] - number_of_day) > 0).blank? ? true: false          
  end
  
  def add_rejected_leave(leave_type: "Sick", no_of_leave: 1)
    self.available_leave[leave_type] = self.available_leave[leave_type] + no_of_leave
    self.save
  end 
 
  def deduct_available_leave(leave_type: "Sick", no_of_leave: 1)
    self.available_leave[leave_type] = self.available_leave[leave_type] - no_of_leave
    self.save 
  end 
end
