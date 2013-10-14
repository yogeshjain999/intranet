class UserMailer < ActionMailer::Base

  def invitation(sender, receiver)
    @sender = sender
    @receiver = receiver
    mail(from: @sender.email, to: @receiver.email, subject: "Invitation to join Josh Intranet")
  end

  def verification(sender, receiver)
    @sender = sender
    @receiver = receiver
    mail(from: @sender.email, to: @receiver.email, subject: "Verify updated User Profile.")
  end
  
  def leave_application(user, receiver: 'hr@joshsoftware.com', from_date: Date.today , to_date: Date.today)
    @user = user
    @receiver = receiver
    @from_date = from_date
    @to_date = to_date     
  end
end
