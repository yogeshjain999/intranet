class UserMailer < ActionMailer::Base

  def invitation(sender, receiver)
    @sender = sender
    @receiver = receiver
    mail(from: @sender.email, to: @receiver.email, subject: "Invitation to join Josh Intranet")
  end
end
