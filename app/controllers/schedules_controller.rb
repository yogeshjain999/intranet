require 'calendar_api'

class SchedulesController < ApplicationController

	def index
		p "I AM HERE AMMU"
		@events= CalendarApi.list_events(current_user)
	end

	def new
		
	end

	def create
	end

	def destroy
		CalendarApi.delete_event(current_user, params[:id])
		redirect_to schedules_path
	end

	def show
		@event= CalendarApi.get_event(current_user, params[:id])
	end

	def edit
	end

	def update
	end

end