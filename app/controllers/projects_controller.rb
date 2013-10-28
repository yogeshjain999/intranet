class ProjectsController < ApplicationController
  load_and_authorize_resource 
  skip_load_and_authorize_resource :only => :create
  before_action :authenticate_user!
  before_action :load_project, except: [:index, :new, :create]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(safe_params)
    if @project.save
      flash[:notice] = "Project created Succesfully"
      redirect_to projects_path
    else
      render 'new'
    end
  end
  
  def update
    if @project.update_attributes(safe_params)
     flash[:notice] = "Project updated Succesfully" 
     redirect_to projects_path
    else
      flash[:alert] = "Project: #{@project.errors.full_messages.join(',')}" 
      render 'edit'
    end
  end

  def show
    @users = @project.users
  end
  
  def destroy
    if @project.destroy
     flash[:notice] = "Project deleted Succesfully" 
    else
     flash[:notice] = "Error in deleting project"
    end
     redirect_to projects_path
  end

  private
  def safe_params
    params.require(:project).permit(:name, :code_climate_id, :code_climate_snippet, :is_active)
  end

  def load_project
    @project = Project.find(params[:id])
  end
end
