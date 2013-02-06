class UserMailer < ActionMailer::Base
  #default:from =>  $u.email

  def leaveReport(leave, user, user_role)
    @user = user
         @leave = leave
    @user_role = user_role
    mail(:from => @user.email, :to => @user_role, :subject => "Apply leave", :template_path => "user_mailer", :template_name => "emailMessage")
  end
end
