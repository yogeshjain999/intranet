require 'spec_helper'
require 'rake'
load File.expand_path("../../../lib/tasks/leave_reminder.rake", __FILE__)
describe LeaveApplicationsController do
  context "Employee, manager and HR" do
    before(:each) do
      @admin = FactoryGirl.create(:user, email: 'admin@joshsoftware.com', role: 'Admin') 
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
    
    context "leaves view" do
      before (:each) do
        leave_type = FactoryGirl.create(:leave_type)
        @user.build_private_profile(FactoryGirl.build(:private_profile).attributes)
        @user.public_profile = FactoryGirl.build(:public_profile)
        @user.save
        @user.leave_details.should_not be([])
        @leave_application = FactoryGirl.build(:leave_application, user_id: @user.id)
        post :create, {user_id: @user.id, leave_application: @leave_application.attributes.merge(leave_type_id: leave_type.id, number_of_days: 2)}
        user2 = FactoryGirl.create(:user, id: "52b28303dd1b36927d000009", email: 'user2@joshsoftware.com', role: 'Employee')  
        user2.build_private_profile(FactoryGirl.build(:private_profile).attributes)
        user2.public_profile = FactoryGirl.build(:public_profile)
        user2.save
        user2.leave_details.should_not be([])
        @leave_application = FactoryGirl.build(:leave_application, user_id: user2.id)
        post :create, {user_id: user2.id, leave_application: @leave_application.attributes.merge(leave_type_id: leave_type.id, number_of_days: 2)}
      end
      
      it "should show only his leaves if user is not admin" do
        get :view_leave_status
        assigns(:pending_leave).count.should eq(1)
      end

      it "user is admin he could see all leaves" do
        sign_out @user
        sign_in @admin
        p LeaveApplication.all.count, LeaveApplication.all.collect(&:user_id), LeaveApplication.all.to_a
        get :view_leave_status
        assigns(:pending_leave).count.should eq(2) 
      end
    end

    it "should be able to apply sick leave" do
      leave_type = FactoryGirl.create(:leave_type)
      @user.build_private_profile(FactoryGirl.build(:private_profile).attributes)
      @user.public_profile = FactoryGirl.build(:public_profile)
      @user.save
      @user.leave_details.should_not be([])
      post :create, {user_id: @user.id, leave_application: @leave_application.attributes.merge(leave_type_id: leave_type.id, number_of_days: 2)}
      LeaveApplication.count.should == 1 
      @user.reload 
      leave_detail = @user.leave_details.last
      remaining_leave = SICK_LEAVE - @leave_application.number_of_days
      leave_detail.available_leave["Sick"].should be(remaining_leave)
    end
    
    it "should not able to apply leave if not sufficient leave" do
      leave_type = FactoryGirl.create(:leave_type, name: 'Privilege')
      @user.build_private_profile(FactoryGirl.build(:private_profile).attributes)
      @user.public_profile = FactoryGirl.build(:public_profile)
      @user.save
      @user.leave_details.should_not be([])
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["TotalPrivilege"] = leave_detail.available_leave["CurrentPrivilege"] = 7
      leave_detail.save
      post :create, {user_id: @user.id, leave_application: @leave_application.attributes.merge(leave_type_id: leave_type.id, number_of_days: 9)}
      LeaveApplication.count.should == 0 
      @user.reload
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["TotalPrivilege"].to_f.should eq(7.0)
      leave_detail.available_leave["CurrentPrivilege"].to_f.should eq(7.0)
    end
    
    it "should be able to apply privilege leave" do
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
      leave_detail.available_leave["TotalPrivilege"].to_f.should eq(12.0)  
      leave_detail.available_leave["CurrentPrivilege"].to_f.should eq(12.0)  
    end
  end
  
  context "AS HR" do
    before(:each) do
      admin = FactoryGirl.create(:user, email: 'admin@joshsoftware.com', role: 'Admin') 
      @user = FactoryGirl.create(:user, email: 'hr@joshsoftware.com', role: 'HR', private_profile: FactoryGirl.build(:private_profile, date_of_joining: Date.new(Date.today.year, 01, 01))) 
      #user = FactoryGirl.create(:user, role: 'Employee')
      sign_in @user
      @leave_application = FactoryGirl.build(:leave_application, user_id: @user.id) 
    end
    
    it "should be able to apply leave" do
      get :new, {user_id: @user.id}
      should respond_with(:success)
      should render_template(:new)
    end

    it "should be able to view all leave" do
      leave_type = FactoryGirl.create(:leave_type, name: 'Sick')
      @leave_application.leave_type_id = leave_type.id
      @leave_application.save
      get :index
      should respond_with(:success)
      should render_template(:index)
    end
    
  end

  context "While accepting leaves" do
    before(:each) do
      @admin = FactoryGirl.create(:user, email: 'admin@joshsoftware.com', role: 'Admin') 
      @hr = FactoryGirl.create(:user, email: 'hr@joshsoftware.com', role: 'HR') 
      @user = FactoryGirl.create(:user, private_profile: FactoryGirl.build(:private_profile, date_of_joining: Date.new(Date.today.year, 01, 01))) 
      sign_in @admin
    end
  
    it "Admin as a role should accept sick leaves " do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["Sick"] = leave_detail.available_leave["Casual"] = SICK_LEAVE - leave_application.number_of_days 
      leave_detail.save
      get :approve_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Approved" 
    end
    
    it "Only single mail to employee should get sent on leave appproval" do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      Sidekiq::Extensions::DelayedMailer.jobs.clear
      get :approve_leave, {id: leave_application.id}
      Sidekiq::Extensions::DelayedMailer.jobs.size.should eq(1)
    end
    
    it "Admin as a role should accept privilege leaves " do
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["TotalPrivilege"] = leave_detail.available_leave["CurrentPrivilege"] = 9
      leave_detail.save 
      leave_type = FactoryGirl.create(:leave_type, name: 'Privilege')
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      leave_detail = @user.reload.leave_details.last
      leave_detail.available_leave["CurrentPrivilege"] = leave_detail.available_leave["TotalPrivilege"] = 9 
      leave_detail.save
      get :approve_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Approved" 
    end 

    it "Admin as a role should to able perform accept(or reject) only one time" do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["Sick"] = leave_detail.available_leave["Casual"] = SICK_LEAVE - leave_application.number_of_days 
      leave_detail.save
      get :approve_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Approved" 
      
      get :cancel_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Approved" 
    end 

    it "should be able to apply leave" do
      get :new, {user_id: @admin.id}
      should respond_with(:success)
      should render_template(:new)
    end

    it "should be able to view all leave" do
      leave_type = FactoryGirl.create(:leave_type, name: 'Sick')
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      get :index
      should respond_with(:success)
      should render_template(:index)
    end 
  end

  context "Canceling leaves" do
    it "Should be credited in corresponding account"
    it "Admin should be canceled after accepting or rejecting"
    it "Employee should be able to cancel when leaves are not accepted or rejected"
    it "After accepting leaves, employee should not be canceled"
    it "If employee cancel leaves then admin should be notified"
    it "Admin cancel leaves then employee should be notified"
  end

  context 'If user is not Admin should not able to ' do

    before do 
      @user = FactoryGirl.create(:user, email: 'employee1@joshsoftware.com', private_profile: FactoryGirl.build(:private_profile, date_of_joining: Date.new(Date.today.year, 01, 01))) 
      user = FactoryGirl.create(:user, email: 'employee2@joshsoftware.com')
      sign_in @user
    end

    after do
      flash[:error].should eq("Unauthorize access")
    end

    it ' Approve leave' do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      get :approve_leave, {id: leave_application.id}
    end

    it ' Reject leave' do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      get :cancel_leave, {id: leave_application.id}
    end

  end

  context "Rejecting leaves" do

    before(:each) do
      @admin = FactoryGirl.create(:user, email: 'admin@joshsoftware.com', role: 'Admin') 
      @hr = FactoryGirl.create(:user, email: 'hr@joshsoftware.com', role: 'HR') 
      @user = FactoryGirl.create(:user, private_profile: FactoryGirl.build(:private_profile, date_of_joining: Date.new(Date.today.year, 01, 01))) 
      sign_in @admin
    end

    it "Reason should get updated on rejection " do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      reason = 'Invalid Reason'
      get :cancel_leave, {id: leave_application.id, reject_reason: reason}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Rejected"
      leave_application.reject_reason.should == reason
    end

    it "Admin as a role should Reject sick leaves " do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["Sick"] = SICK_LEAVE - leave_application.number_of_days 
      leave_detail.save
      get :cancel_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Rejected"

      leave_detail = @user.reload.leave_details.last
      leave_detail.available_leave["Sick"].should eq(SICK_LEAVE)
    end

    it "Admin as a role should Reject Casual leaves " do
      leave_type = FactoryGirl.create(:leave_type, name: 'Casual')
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["Casual"] = CASUAL_LEAVE - leave_application.number_of_days 
      leave_detail.save!
      get :cancel_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Rejected"

      leave_detail = @user.reload.leave_details.last
      leave_detail.available_leave["Casual"].should eq(CASUAL_LEAVE)
    end

    it "Only single mail to employee should get sent on leave rejection" do
      leave_type = FactoryGirl.create(:leave_type, name: 'Casual')
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      Sidekiq::Extensions::DelayedMailer.jobs.clear
      get :cancel_leave, {id: leave_application.id}
      Sidekiq::Extensions::DelayedMailer.jobs.size.should eq(1)
    end

    it "Admin as a role should reject privilege leaves " do
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["TotalPrivilege"] = leave_detail.available_leave["CurrentPrivilege"] = 9
      leave_detail.save

      leave_type = FactoryGirl.create(:leave_type, name: 'Privilege')
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)

      leave_detail.available_leave["TotalPrivilege"] = leave_detail.available_leave["CurrentPrivilege"] = 9 - leave_application.number_of_days
      leave_detail.save
      get :cancel_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Rejected"

      leave_detail = @user.reload.leave_details.last
      leave_detail.available_leave["TotalPrivilege"].to_f.should eq(9.0)
      leave_detail.available_leave["CurrentPrivilege"].to_f.should eq(9.0)
    end 

    it "should not able to revert to accept status once rejected" do
      leave_type = FactoryGirl.create(:leave_type)
      leave_application = FactoryGirl.create(:leave_application, user_id: @user.id, number_of_days: 2, leave_type_id: leave_type.id)
      leave_detail = @user.leave_details.last
      leave_detail.available_leave["Sick"] = leave_detail.available_leave["Casual"] = SICK_LEAVE - leave_application.number_of_days 
      leave_detail.save
      get :cancel_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Rejected" 

      get :approve_leave, {id: leave_application.id}
      leave_application = LeaveApplication.last
      leave_application.leave_status.should == "Rejected" 
    end 
  end

  context 'If leave type is ' do
    
    it "'Sick' and number of days are >= 3 should give notification for medical certificate" do
      @user = FactoryGirl.create(:user, role: 'Employee')
      sign_in @user
      @leave_application = FactoryGirl.build(:leave_application, user_id: @user.id)
      leave_type = FactoryGirl.create(:leave_type)
      @user.build_private_profile(FactoryGirl.build(:private_profile).attributes)
      @user.public_profile = FactoryGirl.build(:public_profile)
      @user.save
      @user.leave_details.should_not be([])
      post :create, {user_id: @user.id, leave_application: @leave_application.attributes.merge(leave_type_id: leave_type.id, number_of_days: 3)}
      flash[:error].should eq('You have to submit medical certificate.')
    end
 
    it "'Casual' then number of days are > 2 should not allow"
  end

  context 'Update', update_leave: true do
    let(:employee) { FactoryGirl.create(:user) }
    let(:leave_app) { FactoryGirl.create(:leave_application, user_id: employee.id) }

    it 'Admin should be able to update leave' do
      sign_in FactoryGirl.create(:admin)
      end_at, days = leave_app.end_at.to_date + 1.day, leave_app.number_of_days + 1
      post :update, id: leave_app.id, leave_application: { "end_at"=> end_at, "number_of_days"=> days }
      l_app = assigns(:leave_application)
      l_app.number_of_days.should eq(days)
      l_app.end_at.should eq(end_at)
    end

    it 'Employee should be able to update his own leave' do
      sign_in employee
      end_at, days = leave_app.end_at.to_date + 1.day, leave_app.number_of_days + 1
      post :update, id: leave_app.id, leave_application: { "end_at"=> end_at, "number_of_days"=> days }
      l_app = assigns(:leave_application)
      l_app.number_of_days.should eq(days)
      l_app.end_at.should eq(end_at)
    end

    it 'Employee should not be able to update leave of other employee' do
      sign_in FactoryGirl.create(:user)
      end_at, days = leave_app.end_at.to_date + 1.day, leave_app.number_of_days + 1
      post :update, id: leave_app.id, leave_application: { "end_at"=> end_at, "number_of_days"=> days }
      flash[:alert].should eq("You are not authorized to access this page.")
      l_app = assigns(:leave_application)
      l_app.number_of_days.should eq(leave_app.number_of_days)
      l_app.end_at.should eq(leave_app.end_at)
    end

    it 'number of days should get updated if updated' do
      sign_in employee
      end_at, days = leave_app.end_at.to_date + 1.day, leave_app.number_of_days + 1
      l_type = leave_app.leave_type.name
      leave_details = employee.get_leave_detail(Date.today.year)
      leave_details.available_leave[l_type] = 10
      leave_details.save
      post :update, id: leave_app.id, leave_application: { "end_at"=> end_at, "number_of_days"=> days }
      l_app = assigns(:leave_application)
      l_app.number_of_days.should eq(days)
      l_app.end_at.should eq(end_at)
      leave_details.reload.available_leave[l_type].should eq(9)
    end

  end

  context 'Update', update_leave: true do
    let(:employee) { FactoryGirl.create(:user) }
    let(:leave_app) { FactoryGirl.create(:leave_application, user_id: employee.id) }

    it 'should update available leaves if leave type and number of days changed' do
      sign_in employee
      leave_type2 = FactoryGirl.create(:casual_type)

      end_at, days = leave_app.end_at.to_date + 1.day, leave_app.number_of_days - 1
      l_type_name = leave_app.leave_type.name
      leave_details = employee.get_leave_detail(Date.today.year)
      available_l_type = leave_details.available_leave[l_type_name]
      leave_details.available_leave[leave_type2.name] = 10
      leave_details.save
      available_leaves = leave_details.available_leave[l_type_name]

      days.should <= 2

      post :update, id: leave_app.id, leave_application: { "end_at"=> end_at, "number_of_days"=> days, leave_type_id: leave_type2.id}

      l_app = assigns(:leave_application)
      l_app.leave_type_id.should eq(leave_type2.id)
      leave_details.reload.available_leave[l_type_name].should eq(available_l_type + leave_app.number_of_days)
      leave_details.reload.available_leave[leave_type2.name].should eq(10 - days)

    end

  end

end

