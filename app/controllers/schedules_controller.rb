require 'calendar_api.rb'
require 'date.rb'
require 'schedule_helper.rb'

class SchedulesController < ApplicationController

	def index
		if user_signed_in? && current_user.role == 'HR'
				if (!params[:starts_at])
					@events= CalendarApi.list_events(current_user)
				else
					@events= CalendarApi.list_events_between_dates(current_user,params[:starts_at],params[:ends_at])
				end
		end
	end

	def today
		@events= CalendarApi.list_events_between_dates(current_user, Date.today.strftime("%m/%d/%Y"), Date.today.strftime("%m/%d/%Y"))
	end

	def new

		@schedule= Schedule.new
		@emails = User.all.collect {|p| [p.email]}
	end

	def get_interviewers(event, interviewers)
		interviewers.each do |interviewer|
			if (interviewer!= "")
				user= User.any_of(:email=>interviewer).to_a
				@schedule.users << user
				event["attendees"].push('email' => interviewer)
			end
		end
		event
	end

	def create
		user= params[:user]
		@schedule= Schedule.new(allow_params)
		@schedule.status= "confirmed"

		interviewers= user["email"]
		datetime= ScheduleHelper.convert_into_rfc3339(@schedule)
		event= ScheduleHelper.make_event(@schedule, datetime)
		event= get_interviewers(event, interviewers)

		CalendarApi.create_event(current_user, event)
		id = CalendarApi.fetch_event(current_user, @schedule.summary)
		@schedule.google_id = id
		@schedule.save
    redirect_to schedules_path
	end

	def destroy
		CalendarApi.delete_event(current_user, params[:id])
		Schedule.where(google_id: params[:id]).delete
		redirect_to schedules_path
	end

	def show
		@schedule= Schedule.where(google_id: params[:id]).first
		@event= CalendarApi.get_event(current_user, params[:id])
	end

	def edit
		
		@schedule= Schedule.find(params[:id])
		@emails = User.all.collect {|user| user.email}
	end

	def update
		@schedule= Schedule.where(google_id: params[:id]).first
		@schedule.update_attributes(allow_params)
		interviewers= allow_params[:user_ids]
		datetime= ScheduleHelper.convert_into_rfc3339(@schedule)
		event= ScheduleHelper.make_event(@schedule, datetime)
		event= get_interviewers(event, interviewers)

		@schedule.save
		CalendarApi.update_event(current_user, @schedule.google_id, event)
    redirect_to schedules_path
	end

	def get_event_status

		@schedule= Schedule.find(params[:schedule_id])
		@schedule.status= (params[:status])
		@schedule.save
		redirect_to schedules_path		
	end

	def event_status
		@schedule= Schedule.find(params[:schedule_id])		
	end

	def feedback
	
		@schedule= Schedule.where(google_id: params[:google_id]).first
		@schedule.feedback[params["attendee_name"]]= params[:comment]	
		@schedule.save
		redirect_to schedule_path(params[:google_id])
	end

  def allow_params
  	params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :interview_type, :google_id, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin],:user_ids =>[])
  end

end
