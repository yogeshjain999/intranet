require "spec_helper"

describe LeaveTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/leave_types").should route_to("leave_types#index")
    end

    it "routes to #new" do
      get("/leave_types/new").should route_to("leave_types#new")
    end

    it "routes to #show" do
      get("/leave_types/1").should route_to("leave_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/leave_types/1/edit").should route_to("leave_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/leave_types").should route_to("leave_types#create")
    end

    it "routes to #update" do
      put("/leave_types/1").should route_to("leave_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/leave_types/1").should route_to("leave_types#destroy", :id => "1")
    end

  end
end
