class UserMailer < ActionMailer::Base
  default :from =>  "notification@joshintranet.com"

  def leaveReport(users)
     @user = users
    # @url = "http://joshintranet.com"
    mail(:to => users.email, :subject => "Apply leave", :template_path => "user_mailer", :template_name => "emailMessage")
  end

#    def receive(email)     
 #    page = Page.find_by_address(email.to.first)     
#      page.emails.create(:subject => email.subject, :body => email.body)       
#      if email.has_attachments?       
#        email.attachments.each do |attachment|         
#        page.attachments.create({
#      		 :file => attachment,           
#		:description => email.subject         
#      })       
#      end    
#      end  
#      end

end
