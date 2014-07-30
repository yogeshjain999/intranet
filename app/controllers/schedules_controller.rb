require 'calendar_api.rb'
require 'date.rb'

class SchedulesController < ApplicationController

	def index
		if user_signed_in? 
			if current_user.role == 'HR'
			#if (@events!= nil)

				if (!params[:starts_at])
					@events= CalendarApi.list_events(current_user)
				else
					@events= CalendarApi.list_events_between_dates(current_user,params[:starts_at],params[:ends_at])
				end
			#end
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

	def make_event(schedule, datetime)
		event = {
			'summary'=> schedule.summary,
			'description'=> schedule.description,
			'start'=> {'dateTime' => datetime },
			'end' => {'dateTime' => datetime },
			'sendNotifications' => true,

				'attendees'=> [
			    {
			      'email'=> schedule.candidate_details[:email],
			      'displayName'=> "Interviewee",
			    },
			  ] 			
		}
		event
	end

	def convert_into_rfc3339(schedule)
		time = schedule.interview_time.to_s		

		#TimePicker returns today's date along with time. Hence manipulating string to take only time
		dt= schedule.interview_date.to_s + time[10, time.length]
		#DateTime getting parsed in GMT. Hence manipulating string into IST.
		tempdatetime= DateTime.parse(dt).rfc3339
		datetime =  tempdatetime[0,tempdatetime.length-5]+"05:30"

		datetime
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
		datetime= convert_into_rfc3339(@schedule)
		event= make_event(@schedule, datetime)
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
		#@schedule= Schedule.where(google_id: params[:id]).first
		@emails = User.all.collect {|user| user.email}
	end


	def update_schedule_in_database

		@schedule= Schedule.where(google_id: params[:id]).first
		@schedule.users=[]
		@schedule.update_attributes(summary: allow_params[:summary], description: allow_params[:description], interview_date: allow_params[:interview_date], interview_time: allow_params[:interview_time], interview_type: allow_params[:interview_type], candidate_details: allow_params[:candidate_details], public_profile: allow_params[:public_profile])

		@schedule
	end

	def update
		@schedule= update_schedule_in_database
		interviewers= allow_params[:user_ids]
		datetime= convert_into_rfc3339(@schedule)
		event= make_event(@schedule, datetime)
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

		#CalendarApi.add_comment(current_user, params[:google_id], params[:attendee_email], params[:comment])
		redirect_to schedule_path(params[:google_id])
	end

  def allow_params
  	params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :interview_type, :google_id, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin],:user_ids =>[])
  end

end
