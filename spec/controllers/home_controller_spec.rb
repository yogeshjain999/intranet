require 'spec_helper'

describe HomeController do
  
  context "GET index" do
    it "should find all active record" do
      p1 = FactoryGirl.create(:project, name: "Intranet", is_active: 'true')
      p2 = FactoryGirl.create(:project, name: "UP", is_active: 'true')
      get :index
      projects = Project.all_active
      expect(assigns(:projects)).to eq(projects)
    end
  end
end
