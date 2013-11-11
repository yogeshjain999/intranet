class LeaveDetail
  include Mongoid::Document
  belongs_to :user
  
  field :year,            type: Integer
  
  field :available_leave,     type: Hash, default: {"Sick" => 0, "Casual" => 0, "CurrentPrivilege" => 0, "TotalPrivilege" => 0}
  
  before_save do
    self.available_leave["Sick"] = self.available_leave["Sick"].to_i
    self.available_leave["Casual"] = self.available_leave["Casual"].to_i
    self.available_leave["CurrentPrivilege"] = self.available_leave["CurrentPrivilege"].to_i
    self.available_leave["TotalPrivilege"] = self.available_leave["TotalPrivilege"].to_i
  end

  
  def self.details
    user_ids = User.not_in(role: ["Admin", "SuperAdmin"]).pluck(:id)
    self.includes(:user).where(:user_id.in => user_ids).to_a 
  end 
 
  def monthly_paid_leave
    if (self.user.private_profile.date_of_joining.month == (Date.today.month-1) && self.user.private_profile.date_of_joining <= 15) || (self.user.private_profile.date_of_joining.month != (Date.today.month-1))
      self.available_leave["CurrentPrivilege"] += 1.5
      self.available_leave["TotalPrivilege"] += 1.5
    end
    self 
  end
  
  def validate_leave(name, number_of_day)
    if name == "Privilege"
      name = "TotalPrivilege"
    end

    ((self.available_leave[name] - number_of_day) > 0).blank? ? true: false          
  end
  
  def add_rejected_leave(leave_type: "Sick", no_of_leave: 1)
    if leave_type != "Privilege"
      self.available_leave[leave_type] = self.available_leave[leave_type] + no_of_leave.to_i if leave_type != "Privilege"
    else
      self.available_leave["CurrentPrivilege"] +=  no_of_leave.to_i
      self.available_leave["TotalPrivilege"] +=  no_of_leave.to_i
    end
    self.save
  end 
  
  
   
  def deduct_available_leave(leave_type: "Sick", no_of_leave: 1)
    if leave_type != "Privilege"
      self.available_leave[leave_type] = self.available_leave[leave_type] - no_of_leave
    else
      self.available_leave["CurrentPrivilege"] -=  no_of_leave if self.available_leave["CurrentPrivilege"] == 0 
      self.available_leave["TotalPrivilege"] -=  no_of_leave
    end 
    self.save 
  end 
end
