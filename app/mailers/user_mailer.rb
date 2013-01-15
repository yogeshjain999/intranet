class UserMailer < ActionMailer::Base
  default :from =>  "notification@joshintranet.com"

  def leaveReport(users, leave)
     @user = users
     #organizationName = users.organization.name + '.'
     #userPath = url_for( @user )
     @url = url_for( @user )
     @leave = leave
    mail(:to => users.email, :subject => "Apply leave", :template_path => "user_mailer", :template_name => "emailMessage")
  end
end
