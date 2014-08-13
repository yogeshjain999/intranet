require 'calendar_api'
require 'schedule_helper'

class SchedulesController < ApplicationController
	load_and_authorize_resource
	
  def index
		if user_signed_in? && current_user.role == 'HR'
				if (!params[:starts_at])
					@future_events = Schedule.where(:interview_date.gt => Date.today)
					@past_events = Schedule.where(:interview_date.lt => Date.today)
					@today_events = Schedule.where(interview_date: Date.today)
					@all_events = Schedule.all
				else

					start_date = Date.strptime(params[:starts_at], "%m/%d/%Y")
					end_date = Date.strptime(params[:ends_at], "%m/%d/%Y")
					@future_events = Schedule.where(:interview_date.gt => Date.today).and(:interview_date.lte => end_date)
					@today_events = Schedule.where(interview_date: Date.today).and(:interview_date.gte => start_date ).and(:interview_date.lte => end_date)
					@past_events = Schedule.where(:interview_date.lt => Date.today).and(:interview_date.gte => start_date)
					@all_events = Schedule.where(:interview_date.gte => start_date).and(:interview_date.lte => end_date)
				end
		end
	end

	def new
		@emails = User.all.collect(&:email)
	end


	def create
		@schedule.status= "Scheduled"
		@emails = User.all.collect(&:email)

		interviewers = params[:user][:email]
		#TODO interviewers << "hr@joshsoftware.com"		
		datetime = ScheduleHelper.convert_into_rfc3339(@schedule)
		event = ScheduleHelper.make_event(@schedule, datetime)
		event = get_interviewers(event, interviewers)

		result = CalendarApi.create_event(event)
    if result && result.response.env.status == 200
      body = JSON.load(result.response.env.body)
      @schedule.google_id = body['id']
      @schedule.save
      redirect_to schedules_path
    else
      flash[:error] = "Failed to create event"
      render :new
    end
  end

  def destroy
    result = CalendarApi.delete_event(@schedule.google_id)
    if result && (result.response.env.status == 204 || result.response.env.status == 410)
      @schedule.delete
      redirect_to schedules_path
    else
      flash[:error] = "Failed to delete event"
      redirect_to action: 'index'
    end
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

  private

  def schedule_params
    params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :interview_type, :google_id, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin], user: [email: []])
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
end
