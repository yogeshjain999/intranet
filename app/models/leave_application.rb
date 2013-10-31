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

  validate :validate_leave_details, on: :create

  after_create :deduct_available_leave_send_mail


  def process_after_update(status)
    send("process_#{status}") 
  end
  
  def process_reject_application
    user = self.user
    user.leave_details.where(year: Date.today.year).first.add_rejected_leave(leave_type: self.leave_type.name, no_of_leave: self.number_of_days)    
    UserMailer.reject_leave(from_date: self.start_at, to_date: self.end_at, user: user) 
  end

  def process_accept_application
    UserMailer.accept_leave(from_date: self.start_at, to_date: self.end_at, user: user)
  end

  private
    def deduct_available_leave_send_mail
      user = self.user
      user.leave_details.where(year: Date.today.year).first.deduct_available_leave(leave_type: self.leave_type.name, no_of_leave: self.number_of_days)    
      user.sent_mail_for_approval(from_date: self.start_at, to_date: self.end_at) 
    end

    def validate_leave_details
      user = self.user
      if user.leave_details.where(year: Date.today.year).first.validate_leave(self.leave_type.name, self.number_of_days) 
        errors.add(:base, 'Not Sufficient Leave !Contact Administrator ') 
      end
    end
end
