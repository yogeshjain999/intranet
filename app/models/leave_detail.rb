class LeaveDetail
  include Mongoid::Document
  belongs_to :user
  
  field :year,            type: Integer
  
  field :available_leave,     type: Hash, default: {"Sick" => 0, "Casual" => 0, "CurrentPaid" => 0, "TotalPaid" => 0}
  
  before_save do
    self.available_leave["Sick"] = self.available_leave["Sick"].to_i
    self.available_leave["Casual"] = self.available_leave["Casual"].to_i
    self.available_leave["CurrentPaid"] = self.available_leave["CurrentPaid"].to_i
    self.available_leave["TotalPaid"] = self.available_leave["TotalPaid"].to_i
  end

  
  def self.details
    user_ids = User.not_in(role: ["Admin", "SuperAdmin"]).pluck(:id)
    self.includes(:user).where(:user_id.in => user_ids).to_a 
  end 
 
  def monthly_paid_leave
    if (self.user.private_profile.date_of_joining.month == (Date.today.month-1) && self.user.private_profile.date_of_joining <= 15) || (self.user.private_profile.date_of_joining.month != (Date.today.month-1))
      self.available_leave["CurrentPaid"] += 1.5
      self.available_leave["TotalPaid"] += 1.5
    end
    self 
  end
  
  def validate_leave(name, number_of_day)
    if name == "Paid"
      name = "TotalPaid"
    end

    ((self.available_leave[name] - number_of_day) > 0).blank? ? true: false          
  end
  
  def add_rejected_leave(leave_type: "Sick", no_of_leave: 1)
    if leave_type != "Paid"
      self.available_leave[leave_type] = self.available_leave[leave_type] + no_of_leave.to_i if leave_type != "Paid"
    else
      self.available_leave["CurrentPaid"] +=  no_of_leave.to_i
      self.available_leave["TotalPaid"] +=  no_of_leave.to_i
    end
    self.save
  end 
  
  
   
  def deduct_available_leave(leave_type: "Sick", no_of_leave: 1)
    if leave_type != "Paid"
      self.available_leave[leave_type] = self.available_leave[leave_type] - no_of_leave
    else
      self.available_leave["CurrentPaid"] -=  no_of_leave if self.available_leave["CurrentPaid"] == 0 
      self.available_leave["TotalPaid"] -=  no_of_leave
    end 
    self.save 
  end 
end
