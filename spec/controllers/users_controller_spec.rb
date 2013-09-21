require 'spec_helper'

describe UsersController do
  before(:each) do
    #@user = FactoryGirl.create(:user, role: 'Admin')
    #sign_in @user
  end

  context "Inviting user" do
    it 'In order to invite user' do
      get :invite_user
      should respond_with(:success)
      should render_template(:invite_user)
    end
     
    it 'should not invite user without email and role' do
      post :invite_user, {user: {email: "", role: ""}}
      should respond_with(:success)
      should render_template(:invite_user)
    end

    it 'should send invitation mail on success' do
      post :invite_user, {user: {email: "t@t.com", role: "Employee"}}
    end
  end
end
