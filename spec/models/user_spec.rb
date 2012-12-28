require 'spec_helper'

describe User do
 it "Organization first user should be assigned as Admin"
 it "should have at least 1 manager assigned except Admin & HR"
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
 end
end
