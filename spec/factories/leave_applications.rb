# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :leave_application do |l|
    starts_at Date.today + 2
    ends_at Date.today + 3
    reason "Sick"
    contact_number "1234567890"
    l.association(:address)
  end
end
