class HomeController < ApplicationController
  skip_before_filter :current_organization, :authenticate_user!
end
