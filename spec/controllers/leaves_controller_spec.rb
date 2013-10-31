require 'spec_helper'

describe LeaveApplicationsController do
  context "Employee, manager and HR" do
    before(:each) do
      @user = FactoryGirl.create(:user, role: 'Employee')
      sign_in @user
      @leave_application = FactoryGirl.build(:leave_application)
    end

    it "should able to view new leave apply page" do
      get :new, {user_id: @user.id}
      should respond_with(:success)
      should render_template(:new) 
    end
    
    it "should raise exception when submitting leave without entering user date of joining." do
      expect{ post :create, {user_id: @user.id, leave_application: @leave_application.attributes}}.to raise_error(NoMethodError) 
    end

    it "should be able to apply leave" do
      @user.private_profile = FactoryGirl.build(:private_profile)
      @user.public_profile = FactoryGirl.build(:public_profile)
      @user.save
      post :create, {user_id: @user.id, leave_application: @leave_application.attributes}
      LeaveApplication.count.should == 1 
    end
  end

 context "While accepting leaves" do
  it "Admin as a role should accept leaves for an HR, manager and employee" do

  end
  it "An HR as a role should accept leaves for manager and employee"
  it "Manager as a role should accept leaves for employee"
  it "If leaves are accepted then should deduct from employee's account"
  it "Admin and HR should get an email notification when leaves are accepted"
 end

 context "Canceling leaves" do
  it "Should be credited in corresponding account"
  it "Admin should be canceled after accepting or rejecting"
  it "Employee should be able to cancel when leaves are not accepted or rejected"
  it "After accepting leaves, employee should not be canceled"
  it "If employee cancel leaves then admin should be notified"
  it "Admin cancel leaves then employee should be notified"
 end

 context "Rejecting leaves" do
  it "Admin should reject leaves for an HR, manager and employee"
  it "An HR should reject leaves for manager and employee"
  it "Manager should reject leaves for employee"
  it "There should be reason for rejecting leaves and employee should get notify"
 end
end

