class LeaveDetail
  include Mongoid::Document
  belongs_to :user
  
  field :year,            type: Integer
  field :available_leave,     type: Hash, default: {:Sick => 0, :Casual => 0, :Paid => 0}

  
  def validate_leave(name, number_of_day)
    ((self.available_leave[name] - number_of_day) > 1).blank? ? true: false          
  end
end
