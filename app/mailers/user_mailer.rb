class UserMailer < ActionMailer::Base
  #default :from => @user.email
  #'vishal.pawle@gmail.com'
  #default:from =>  $u.email

  def leaveReport(leave, user, user_role)
    @user = user
         @leave = leave
    @user_role = user_role
#@user_hr = user_hr
#@user_mgr = user_mgr
    #@ur.to_a
     #@url = url_for( @users)

    #@u = u
    #@ur.email.each do |usr|
    mail(:from => @user.email, :to => @user_role.mail.join(','), :subject => "Apply leave", :template_path => "user_mailer", :template_name => "emailMessage")
  end
end
