require 'spec_helper'

describe UsersController do
  context "Inviting user" do
    it 'In order to invite user' do
      user = FactoryGirl.build(:user)
      get :invite_user
      assigns[:user] = user
      should respond_with(:success)
      should render_template(:invite_user)
    end
     
    it 'should not invite user without email and role' do
      post :invite_user, {user: {email: "", role: ""}}
      should render_template(:invite_user)
    end

    it 'should send invitation mail on success' do
      user = FactoryGirl.build(:user, email: 'test@invitee.com', role: 'Employee')
      admin = FactoryGirl.create(:user, role: 'Admin')
      sign_in admin
      post :invite_user, {user: {email: 'test@invitee.com', role: 'Employee'}}
      flash.notice.should eql("Invitation sent Succesfully")
      invite_email = ActionMailer::Base.deliveries.last
      invite_email.should_not be_nil
      should redirect_to(root_path)
    end
  end
end
