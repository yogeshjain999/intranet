require "spec_helper"

describe OrganizationsController do
  describe "routing" do

    it "routes to #new" do
      get("/sign_up").should route_to("organizations#new")
    end

    it "routes to #create" do
      post("/sign_up").should route_to("organizations#create")
    end

  end
end
