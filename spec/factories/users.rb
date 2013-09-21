FactoryGirl.define do
  factory :user do |u|
    u.first_name "fname"
    u.last_name "lname"
    u.email "test@test.com"
    u.password "test123"
  end
end
