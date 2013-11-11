class UserMailer < ActionMailer::Base
  default :from => 'dev-intranet.com@joshsoftware.com' 
  
  def invitation(sender_id, receiver_id)
    @sender = User.where(id: sender_id).first
    @receiver = User.where(id: receiver_id).first
    mail(from: @sender.email, to: @receiver.email, subject: "Invitation to join Josh Intranet")
  end

  def verification(updated_user_id)
    admin_emails = User.where(role: 'Admin').all.map(&:email)
    @updated_user = User.where(id: updated_user_id).first
    hr = User.where(role: 'HR').first
    receiver_emails = [admin_emails, hr.email].flatten.join(',')
    mail(to: receiver_emails , subject: "#{@updated_user.public_profile.name} Profile has been updated")
  end
  
  def leave_application(sender_email, receivers, from_date, to_date)
    @user = User.find_by(email: sender_email)
    @receivers = receivers
    @from_date = from_date
    @to_date = to_date    
      
    mail(from: @user.email, to: receivers, subject: "Leave Application Submitted to Admin")
  end

  def reject_leave(from_date: Date.today, to_date: Date.today, user: nil)
    @from_date = from_date
    @to_date = to_date
    @user = user
    
    mail(from: "admin@joshsofware.com", to: user.email, subject: "Leave Request got rejected")
  end

  def accept_leave(from_date: Date.today, to_date: Date.today, user: nil)
    @from_date = from_date
    @to_date = to_date
    @user = user
    
    mail(from: "admin@joshsofware.com", to: user.email, subject: "Congrats! Leave Request got accepted")
  end
end
