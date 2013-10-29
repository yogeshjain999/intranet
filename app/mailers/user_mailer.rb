class UserMailer < ActionMailer::Base
  default :from => 'dev-intranet.com@joshsoftware.com' 
  
  def invitation(sender_id, receiver_id)
    @sender = User.where(id: sender_id).first
    @receiver = User.where(id: receiver_id).first
    mail(from: @sender.email, to: @receiver.email, subject: "Invitation to join Josh Intranet")
  end

  def verification(updated_user_id)
    admin = User.where(role: 'Super Admin').first
    @updated_user = User.where(id: updated_user_id).first
    hr = User.where(role: 'HR').first
    mail(to: [admin.email, hr.email].join(',') , subject: "#{@updated_user.public_profile.name} Profile has been updated")
  end
  
  def leave_application(sender_email, receivers: ['hr@joshsoftware.com'], from_date: Date.today , to_date: Date.today)
    @user = sender_email
    @receivers = receivers
    @from_date = from_date
    @to_date = to_date    
      
    mail(from: sender_email, to: receivers, subject: "#{@updated_user.public_profile.name} Profile has been updated")
  end
end
