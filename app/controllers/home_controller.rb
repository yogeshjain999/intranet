class HomeController < ApplicationController
  def index
    @projects = Project.all_active
  end
end
