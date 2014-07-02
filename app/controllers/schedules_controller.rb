class SchedulesController < ApplicationController
	def new
		@schedule = Schedule.new
	end
end
