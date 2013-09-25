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
end
