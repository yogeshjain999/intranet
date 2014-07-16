include ActionDispatch::TestProcess
require 'faker'
require 'time'
require 'date'

FactoryGirl.define do
  factory :schedule do
    users {[FactoryGirl.create(:user)]}
    random_object = Random.new
    interview_time Time.at(random_object.rand(1234675678))   
    interview_date "23/2/2015"
    candidate_details do
      {
        email: "abc@gmail.com",
        telephone: "8989898989",
        skype: "skype1"
      }
    end

    public_profile do
      {
        git:"http://github.com/candidate1" ,
        linkedin: "http://in.linkedin.com/pub/avinash-pandey/82/7b3/a17/"
      }
    end
    interview_type "Telephonic"
    file {fixture_file_upload('spec/fixtures/files/sample1.pdf')}
    
  end
end

