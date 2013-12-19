namespace :leave_reminder do
  desc "Remainds admin and HR who are on leave tomorrow."
  task daily: :environment do
    Rails.logger.info("in rake task")
    UserMailer.delay.leaves_reminder
  end

end
