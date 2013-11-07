require 'data_api/bonusly'
class HomeController < ApplicationController
  def index
    @projects = Project.all_active
    #@bonusly_updates = get_bonusly_updates
  end

  def get_bonusly_updates
    bonus = Api::Bonusly.new(size: 10)
    messages = bonus.all_bonusly_messages
    messages
  end
end
