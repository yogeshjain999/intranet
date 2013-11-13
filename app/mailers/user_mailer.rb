class UserMailer < ActionMailer::Base
  default :from => 'intranet@joshsoftware.com' 
  
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
  
  def leave_application(sender_email, receivers, leave_application_id)
    @user = User.find_by(email: sender_email)
    @receivers = receivers
    @leave_application = LeaveApplication.where(id: leave_application_id).first
    mail(from: @user.email, to: receivers, subject: "Leave Application Submitted to Admin")
  end

  def reject_leave(leave_application_id)
    get_leave(leave_application_id)
    mail(from: "admin@joshsofware.com", to: @user.email, subject: "Leave Request got rejected")
  end

  def accept_leave(leave_application_id)
    get_leave(leave_application_id)
    mail(from: "admin@joshsofware.com", to: @user.email, subject: "Congrats! Leave Request got accepted")
  end

  def download_notification(downloader_id, document_name)
    @downloader = User.find(downloader_id)
    @document_name = document_name
    hr = User.where(role: 'HR').first
    mail(to: hr.email, subject: "Intranet: #{@downloader.name} has downloaded #{document_name}")
  end

  private

    def get_leave(id)
      @leave_application = LeaveApplication.where(id: id).first
      @user = @leave_application.user
    end
end
