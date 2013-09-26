require 'spec_helper'

describe UsersController do
  before(:each) do
    @admin = FactoryGirl.create(:user, role: 'Admin', email: "admin@joshsoftware.com")
    sign_in @admin
  end
  context "Inviting user" do
    it 'In order to invite user' do
      get :invite_user
      should respond_with(:success)
      should render_template(:invite_user)
    end

    it 'should not invite user without email and role' do
      post :invite_user, {user: {email: "", role: ""}}
      should render_template(:invite_user)
    end
    
    it 'invitee should have joshsoftware account' do
      post :invite_user, {user: {email: "invitee@joshsoftware.com", role: "Employee"}}
      flash.notice.should eql("Invitation sent Succesfully")
      should redirect_to(root_path)
    end

    it 'should send invitation mail on success' do
      user = FactoryGirl.build(:user, email: 'invitee@joshsoftware.com', role: 'Employee')
      post :invite_user, {user: {email: 'invitee@joshsoftware.com', role: 'Employee'}}
      flash.notice.should eql("Invitation sent Succesfully")
      UserMailer.delay.invitation(@admin, user)
      should redirect_to(root_path)
    end
  end
end
