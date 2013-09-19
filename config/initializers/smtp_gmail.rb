if Rails.env != 'production'
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :user_name => "joshsoftwaretest1@gmail.com",
    :password => "josh1234#",
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
require 'development_mail_interceptor'
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env != 'production'
