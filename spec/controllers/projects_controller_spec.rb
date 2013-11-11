require 'spec_helper'

describe ProjectsController do
  
  before(:each) do
   @admin = FactoryGirl.create(:user, role: 'Admin')
   sign_in @admin
  end
  describe "GET index" do
    it "should list all projects" do
    end

    it "should respond with success" do
      get :index
      should respond_with(:success)
      should render_template(:index)
    end
  end

  describe "GET new" do
    before(:each) do
      get :new
    end

    it "should respond with success" do
      should respond_with(:success)
      should render_template(:new)
    end

    it "should create new project record" do
      assigns(:project).new_record? == true
    end
  end

  describe "GET create" do
    it "should create new project" do
      post :create, {project: {name: "Intranet", code_climate_id: "12345", code_climate_snippet: "Intranet"}}
      flash.notice.should eql("Project created Succesfully")
      should redirect_to projects_path
    end

    it "should not save project without name" do
      project = FactoryGirl.build(:project, name: "")
      post :create, {project: {name: "", code_climate_id: "12345", code_climate_snippet: "Intranet"}}
      expect(project.errors.full_messages).not_to equal([])
      should render_template(:new)
    end
  end

  describe "GET show" do
    it "should find one project record" do
      project = FactoryGirl.create(:project)
      get :show, id: project.id
      expect(assigns(:project)).to eq(project)
    end
  end

  describe "POST edit" do
    
    before(:each) do
      project = FactoryGirl.create(:project)
      get:edit, id: project.id
    end
    
    it "should have project for edit" do
      expect(:project).not_to be(nil)
    end
    
    it "should respond with success" do
      should respond_with(:success)
      should render_template(:edit)
    end
  end

  describe "PATCH update" do
    before(:each) do
      @project = FactoryGirl.create(:project, name: "Intranet")
    end

    it 'should update project' do
      patch :update, { id: @project.id, project: { name: "United Prosperty" } }
      @project.reload
      expect(:project).not_to be(nil)
      expect(@project.name).to eql("United Prosperty")
      expect(flash.notice).to eql("Project updated Succesfully")
      should redirect_to projects_path
    end
    
    it "should not update project if name in not present" do
      patch :update, { id: @project.id, project: {name: ""} }
      expect(flash[:alert]).to eql("Project: Name can't be blank")
      should render_template(:edit)
    end
  end

  describe "DELETE destroy" do
    it "should have valid record" do
      project = FactoryGirl.create(:project)
      delete :destroy, id: project.id
      expect(:project).not_to be(nil)
      expect(flash.notice).to eql("Project deleted Succesfully")
      should redirect_to projects_path
    end
  end
end
