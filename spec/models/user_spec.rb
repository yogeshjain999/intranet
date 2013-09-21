require 'spec_helper'

describe User do

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
=begin
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
