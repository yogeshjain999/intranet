require 'calendar_api.rb'
require 'date.rb'

class SchedulesController < ApplicationController

	def index
		if (!params[:starts_at])
			@events= CalendarApi.list_events(current_user)
		else
			@events= CalendarApi.list_events_by_date(current_user,params[:starts_at])
		end
	end

	def today
		@events= CalendarApi.list_events_by_date(current_user, Date.today.strftime("%m/%d/%Y"))
	end

	def new
		@schedule= Schedule.new
	end

	def create
		@schedule= Schedule.new(params2)
		time = @schedule.interview_time.to_s		

		#TimePicker returns today's date along with time. Hence manipulating string to take only time
		dt= @schedule.interview_date.to_s + time[10, time.length]
		#DateTime getting parsed in GMT. Hence manipulating string into IST.
		tempdatetime= DateTime.parse(dt).rfc3339
		datetime =  tempdatetime[0,tempdatetime.length-5]+"05:30"
		params= allow_params()
		interviewers= params["users_attributes"].collect{|k| k.last["email"]}
		event = {
			'summary'=> @schedule.summary,
			'description'=> @schedule.description,
			'start'=> {'dateTime' => datetime },
			'end' => {'dateTime' => datetime },
				'attendees'=> [
			    {
			      'email'=> @schedule.candidate_details[:email],
			      'displayName'=> "Interviewee",
			    },
			  ] 			
		}

		interviewers.each do |interviewer|
			user= User.any_of(:email=>interviewer[0]).to_a
			@schedule.users << user
			event["attendees"].push('email' => interviewer)
		end

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
		@event= CalendarApi.get_event(current_user, params[:id])
	end

	def edit
		@schedule= Schedule.where(google_id: params[:id]).first
	end

	def update
		@schedule= Schedule.where(google_id: params[:id]).first
		@schedule.summary = (params2[:summary])
		@schedule.description = (params2[:description])
		@schedule.interview_date= (params2[:interview_date])
		@schedule.interview_time= (params2[:interview_time])
		@schedule.interview_type= (params2[:interview_type])
		@schedule.candidate_details= (params2[:candidate_details])
		@schedule.public_profile= (params2[:public_profile])

		time = @schedule.interview_time.to_s		

		#TimePicker returns today's date along with time. Hence manipulating string to take only time
		dt= @schedule.interview_date.to_s + time[10, time.length]
		#DateTime getting parsed in GMT. Hence manipulating string into IST.
		tempdatetime= DateTime.parse(dt).rfc3339
		datetime =  tempdatetime[0,tempdatetime.length-5]+"05:30"
		params= allow_params()
		interviewers= params["users_attributes"].collect{|k| k.last["email"]}
		event = {
			'summary'=> @schedule.summary,
			'description'=> @schedule.description,
			'start'=> {'dateTime' => datetime },
			'end' => {'dateTime' => datetime },
				'attendees'=> [
			    {
			      'email'=> @schedule.candidate_details[:email],
			      'displayName'=> "Interviewee",
			    },
			  ] 			
		}

		interviewers.each do |interviewer|
			user= User.any_of(:email=>interviewer[0]).to_a
			@schedule.users << user
			event["attendees"].push('email' => interviewer)
		end

		@schedule.save
		CalendarApi.update_event(current_user, @schedule.google_id, event)
    redirect_to schedules_path
	end

  def allow_params?
  	puts	params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :file, :interview_type, :google_id, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin], users_attributes: [:email => []])
 
 
  	params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :interview_type, :google_id, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin], users_attributes: [ :_id, :email => []])
  end

  def params2
		params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :file, :interview_type, :google_id, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin])
  end
end
