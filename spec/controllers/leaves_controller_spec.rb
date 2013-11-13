require 'spec_helper'

describe LeaveApplicationsController do
  context "Employee, manager and HR" do
    before(:each) do
       
      hr = FactoryGirl.create(:user, email: 'administrator@joshsoftware.com', role: 'Super Admin') 
      hr = FactoryGirl.create(:user, email: 'admin@joshsoftware.com', role: 'Admin') 
      hr = FactoryGirl.create(:user, email: 'hr@joshsoftware.com', role: 'HR') 
      @user = FactoryGirl.create(:user, role: 'Employee')
      sign_in @user
      @leave_application = FactoryGirl.build(:leave_application, user_id: @user.id)
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
      leave_type = FactoryGirl.create(:leave_type)
      @user.build_private_profile(FactoryGirl.build(:private_profile).attributes)
      @user.public_profile = FactoryGirl.build(:public_profile)
      @user.save
      @user.leave_details.should_not be([])
      post :create, {user_id: @user.id, leave_application: @leave_application.attributes.merge(leave_type_id: leave_type.id)}
      LeaveApplication.count.should == 1 
    end
    it "should be able to apply leave" do
      leave_type = FactoryGirl.create(:leave_type, name: 'Privilege')
      
      @user.build_private_profile(FactoryGirl.build(:private_profile).attributes)
      @user.public_profile = FactoryGirl.build(:public_profile)
      @user.save
      @user.leave_details.should_not be([])
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["TotalPrivilege"] = 19
      leave_detail.available_leave["CurrentPrivilege"] = 19
      leave_detail.save
      @leave_application.attributes.delete("_id")
      post :create, {user_id: @user.id, leave_application: @leave_application.attributes.merge(leave_type_id: leave_type.id, number_of_days: 7)}
      LeaveApplication.count.should == 1 
      @user.reload 
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["TotalPrivilege"].to_f.should be(12.0)  
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

