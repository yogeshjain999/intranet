# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :leave_type do
    name 'Sick' 
  end
  
  factory :casual_type, class: LeaveType do
    name 'Casual' 
  end
  
  factory :privilege_type, class: LeaveType do
    name 'Privilege' 
  end
end
