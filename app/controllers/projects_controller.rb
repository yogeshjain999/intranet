class ProjectsController < ApplicationController
  
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

  def show
    @project = Project.find(params[:id])
  end

  private
  def safe_params
    params.require(:project).permit(:name, :code_climate_id, :code_climate_snippet)
  end
end
