FactoryGirl.define do
  factory :user do |u|
    role 'Employee'
    sequence(:email) {|n| "emp#{n}@joshsoftware.com" }
    password "test123"
    before(:create) { |user| 
      user.public_profile = FactoryGirl.create(:public_profile, user: user)
      user.private_profile = FactoryGirl.create(:private_profile, user: user)
  }
  end

  factory :super_admin, class: User, parent: :user do |u|
    role 'Super Admin'
    sequence(:email) {|n| "superadmin#{n}@joshsoftware.com" }
    password "test123"
  end

  factory :admin, class: User, parent: :user do |u|
    role 'Admin'
    sequence(:email) {|n| "admin#{n}@joshsoftware.com" }
    password "test123"
  end

  factory :hr, class: User, parent: :user do |u|
    role 'HR'
    sequence(:email) {|n| "hrr#{n}@joshsoftware.com" }
    password "test123"
  end
end
