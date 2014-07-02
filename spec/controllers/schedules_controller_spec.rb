require 'spec_helper'

RSpec.describe SchedulesController, :type => :controller do
  context "GET index" do
  	user= FactoryGirl.create(:user)
    
    it "lists all events" do
      @request.env["devise.mapping"] = :user
      sign_in FactoryGirl.create(:user)
      get :index 
      expect(response).to render_template("index")
    end
  end

  context "GET show" do
    user= FactoryGirl.create(:user)
    
    it "shows details of event" do
    	e1= FactoryGirl.create(:schedule)
      @request.env["devise.mapping"] = :user
      sign_in FactoryGirl.create(:user)
      get :show, {id: e1.id}
      expect(response).to render_template("show")
    end
  end

  context "GET delete" do
  user= FactoryGirl.create(:user)

    it "deletes event" do
      e1= FactoryGirl.create(:schedule)
      @request.env["devise.mapping"] = :user
      sign_in FactoryGirl.create(:user)
      get :destroy, {id: e1.id}
      expect(response).to redirect_to schedules_path
    end
  end
end