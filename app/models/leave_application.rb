class LeaveApplication
  include Mongoid::Document
  belongs_to :user
  belongs_to :leave_type
  #has_one :address

  field :start_at,        type: Date
  field :end_at,          type: Date
  field :contact_number,  type: Integer
  field :number_of_days,  type: Integer
  #field :approved_by,     type: Integer
  field :reason,          type: String
  field :reject_reason,   type: String
  field :leave_status,    type: String, default: "Pending"

  LEAVE_STATUS = ['Pending', 'Approved', 'Rejected']

  validates :start_at, :end_at, :contact_number, :reason, :number_of_days, :user_id, :leave_type_id, presence: true 
  validates :contact_number, numericality: {only_integer: true}, length: {is: 10}

  validate :validate_leave_details


  private
    def validate_leave_details
      user = self.user
      
      if user.leave_details.where(year: Date.today.year).first.validate_leave(self.leave_type.name, self.number_of_days) 
        errors.add(:base, 'Not Sufficient Leave !Contact Administrator ') 
      end
    end
end
