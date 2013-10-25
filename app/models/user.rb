class User
  include Mongoid::Document
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]
  ROLES = ['Admin', 'Manager', 'HR', 'Employee']
  ## Database authenticatable
  field :email,               :type => String, :default => ""
  field :encrypted_password,  :type => String, :default => ""
  field :role,                :type => String, :default => "Employee"
  field :uid,                 :type => String
  field :provider,            :type => String        
  field :status,              :type => String, :default => STATUS[0]

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  embeds_one :public_profile
  embeds_one :private_profile
  embeds_one :employee_detail, cascade_callbacks: true
  
  has_many :leave_details
  has_many :leave_applications
  has_many :attachments
  has_and_belongs_to_many :projects

  accepts_nested_attributes_for :private_profile, reject_if: :all_blank, allow_destroy: true 
  accepts_nested_attributes_for :public_profile, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :employee_detail, :attachments, reject_if: :all_blank, :allow_destroy => true

  validates :email, format: {with: /\A.+@joshsoftware.com/, message: "Only Josh email-id is allowed."}
  validates :role, :email, presence: true

  scope :employees, self.in(role: ['Employee', 'Manager'])

  def self.from_omniauth(auth)
    if auth.info.email.include? "joshsoftware.com"
      user = User.where(email: auth.info.email).first
      create_public_profile_if_not_present(user, auth)
      user
    else
      false
    end
  end
  
  def self.create_public_profile_if_not_present(user, auth)
    if user && !user.public_profile?
      user.build_public_profile(first_name: auth.info.first_name, last_name: auth.info.last_name).save
      user.update_attributes(provider: auth.provider, uid: auth.uid)
    end
  end

  def calculate_remaining_leave(total_leave) 
    ((total_leave * (12 - (self.private_profile.date_of_joining.month - 1)))/12).ceil 
  end

  def assign_leave
    leave_details = self.leave_details.build(year: Date.today.year)
    #Logic is that casual 
    leave_details.available_leave[:Sick] = leave_details.available_leave[:Casual] = calculate_remaining_leave(6) 
    leave_details.available_leave[:Paid] = calculate_remaining_leave(PAID_LEAVE) 
    leave_details.available_leave[:Paid] = leave_details.available_leave[:Paid] + 1 if self.private_profile.date_of_joining.month == 6
    leave_details.save
  end   
 
  def set_leave_details_per_year
    available_leave = self.leave_details.where(year: Date.today.year - 1 ).first.available_leave
    current_leave_details = self.leave_details.build(year: Date.today.year) 
    current_leave_details.available_leave[:Sick] = current_leave_details.available_leave[:Casual] = 6
    current_leave_details.available_leave[:Paid] = available_leave[:Paid] > 14 ? 14 : available_leave[:Paid]
    current_leave_details.save 
  end
  
  def sent_mail_for_approval(from_date: Date.today, to_date: Date.today)
    
    notified_users = [
                      User.find_by(role: 'HR').email, User.find_by(role: 'Administrator@joshsoftware.com').email,
                      current_user.employment_details.try(:notification_emails).try(:split, ',')
                     ].flatten.compact.uniq
    notified_users.each do|email|
      UserMailer.delay.leave_application(self, receiver: email, from_date: from_date, to_date: to_date)
    end
  end

  def role?(role)
    self.role == role
  end
end
