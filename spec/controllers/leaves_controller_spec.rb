require 'spec_helper'

describe LeavesController do
 it "Employee, manager and HR should be able to apply for leaves"

 context "While accepting leaves"
  it "Admin as a role should accept leaves for an HR, manager and employee"
  it "An HR as a role should accept leaves for manager and employee"
  it "Manager as a role should accept leaves for employee"
  it "If leaves are accepted then should deduct from employee's account"
  it "Admin and HR should get an email notification when leaves are accepted"
 end

 Context "Canceling leaves"
  it "Should be credited in corresponding account"
  it "Admin should be canceled after accepting or rejecting"
  it "Employee should be able to cancel when leaves are not accepted or rejected"
  it "After accepting leaves, employee should not be canceled"
  it "If employee cancel leaves then admin should be notified"
  it "Admin cancel leaves then employee should be notified"
 end

 context "Rejecting leaves"
  it "Admin should reject leaves for an HR, manager and employee"
  it "An HR should reject leaves for manager and employee"
  it "Manager should reject leaves for employee"
  it "There should be reason for rejecting leaves and employee should get notify"
 end
end

