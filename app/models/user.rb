require "csv"
class User
  include Mongoid::Document
  include Mongoid::Document::Roleable

  include Mongoid::Paperclip 
  has_mongoid_attached_file :leaving_Certificate

  paginates_per 10

  embeds_one :profile
  accepts_nested_attributes_for :profile
  attr_accessible :profile_attributes

  embeds_many :leave_details
  accepts_nested_attributes_for :leave_details
  attr_accessible :leave_details_attributes
  ROLES = ['Admin', 'HR', 'Manager', 'Employee']
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable


  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password , :default => ""
  field :join_date, type: Date
  field :employee_id, type: Integer
  field :probation_end_date, type: Date
  field :pay_role, type: Boolean
  field :next_year_of_probation_date, type: Date
  validates :join_date, :employee_id, :roles, :presence => true
  validates :employee_id, :uniqueness => {:scope => :organization_id}
  validates :email, :uniqueness => {:scope => :organization_id} 
 # validates_attachment :leaving_Certificate, :presence => true, :content_type => { :content_type => ['image/jpg', 'image/png', 'image/jpeg']}

  attr_accessible :email, :password, :password_confirmation, :roles, :organization_id, :join_date, :employee_id, :manager_id, :probation_end_date, :pay_role, :leaving_Certificate
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

	 ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackabler
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip 
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Invitable
  field :invitation_token
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer
  field :invited_by_id, type: Integer
  field :invited_by_type
  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token 

  belongs_to :organization
  has_many :leaves, class_name: "Leave"

  # using self joyngs to maintain the relationship between employee and manager.
  has_many :employees, class_name: "User", :foreign_key => "manager_id"
  belongs_to :manager, class_name: "User"

  # use the name field directly user field for example @user.name
  delegate :name, :to => :profile
  def self.date_of_birth
    date = Date.today+3
  o  = Organization.all
  o.each do |organization|
    admin = organization.users.where(:roles => 'Admin').collect(&:email)
    users = organization.users.in(:roles => ['HR', 'Manager', 'Employee'])
    users.each do |user|
      if user.profile != nil
      if user.profile.dateOfBirth.try(:strftime, "%j").to_i == Date.today.strftime("%j").to_i+3
      UserMailer.date_of_birth(user, admin, date).deliver
      end
    end
  end
  end
  end
  def self.leave_details_every_month
    organization = Organization.all
      organization.each do |o|
    user_admin = User.where(:roles => 'Admin').collect(&:email)
  users  = o.users.in(:roles => ['HR', 'Manager', 'Employee'])
#        another_user = User.in(:roles => ['HR', 'Manager', 'Employee']).collect(&:email)
    users.each do |user|
        user.leave_details.each do |leave|
        if leave.assign_date.year == Time.zone.now.year
    UserMailer.send_leave(user_admin, user.email, leave).deliver
end
end
end
      end
      end
def self.send_mail_to_admin
    organization = Organization.all
    organization.each do |o|

    admin = o.users.where(:roles => 'Admin').collect(&:email)
    user = o.users.in(:roles => ['HR', 'Manager', 'Employee'])
            UserMailer.send_mail_to_admin(admin, user).deliver
	    end
  end
  def self.email_of_probation
    date = Date.today+15
    organization = Organization.all
    organization.each do |o|
      admin = o.users.where(:roles => 'Admin').collect(&:email)
      users = o.users.in(:roles => ['HR', 'Manager', 'Employee'])
      users.each do |user|
        if user.probation_end_date.try(:strftime, "%j").to_i == Date.today.strftime("%j").to_i+15
        UserMailer.email_of_probation(admin, user, date).deliver
        end
      end
    end
  end
end