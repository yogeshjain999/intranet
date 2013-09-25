require 'spec_helper'

describe User do

  it { should have_fields(:email, :encrypted_password, :role, :uid, :provider, :status, :leave_notification) }
  it { should have_field(:status).of_type(String).with_default_value_of(STATUS[0]) }
  it { should embed_one :public_profile }
  it { should embed_one :private_profile }
  it { should accept_nested_attributes_for(:public_profile) }
  it { should accept_nested_attributes_for(:private_profile) }
  it { should validate_presence_of(:role) }
  it { should validate_presence_of(:email) }

=begin
  context "When inviting new user" do
    it "user can invite new user if he is admin" do
      user = FactoryGirl.create(:user, role: "Admin")
      ability = Ability.new(user)
      assert ability.can?(:invite_user, user)
    end

    it "user cannot invite new user if he is not admin" do
      user = FactoryGirl.create(:user, role: "Employee")
      ability = Ability.new(user)
      assert ability.cannot?(:invite_user, user)
    end
  end  
 context "When editing and updating profile"
  it "Should have name"
  it "Should have local address"
  it "Should have permanent address"
  context "Should  have PAN number" do
   it "Should be visible to admin, HR and for that user itself"
   it "Should have 10 alfa numeric characters"
   it "Should have first 5 letters, 4 digits and a letter @ the last"
  end
  it  "Should have Github handle "
  it "Should have twitter handle"
  it "Should have phone number"
  it "Should have date of birth"
  it "Should mention date of joining"
  it "Should mention employee id"
  it "Should have passport number"
=end
end
