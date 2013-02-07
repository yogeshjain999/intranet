class UserMailer < ActionMailer::Base

  def leaveReport(leave, user, user_role)
    @user = user
         @leave = leave
    @user_role = user_role
    mail(:from => @user.email, :to => @user_role, :subject => "Apply leave", :template_path => "user_mailer", :template_name => "emailMessage")
  end


  def rejectStatusLeave(leave, user)
    @user = user
    @leave = leave
    mail(:from => @user.email, :to => @leave.user.email, :subject => ' Leave has been rejected', :template_path => 'user_mailer', :template_name => 'reject')
    end
#end
      def approveLeave(leave, user)
        @leave = leave
        @user = user
        mail(:from => @user.email, :to => @leave.user.email, :subject => "Leave has been approve", :template_path => "user_mailer", :template_name => "appr")
      end
      end