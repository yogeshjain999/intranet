require 'calendar_api.rb'
require 'date.rb'

class SchedulesController < ApplicationController

	def index
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

	def today
		@events= CalendarApi.list_events_by_date(current_user, Date.today.strftime("%m/%d/%Y"))
	end

	def new

		@schedule= Schedule.new
		@emails = User.all.collect {|p| [p.email]}
	end

	def create
		user= params[:user]
		@schedule= Schedule.new(allow_params)
		@schedule.status= "confirmed"
		time = @schedule.interview_time.to_s		

		#TimePicker returns today's date along with time. Hence manipulating string to take only time
		dt= @schedule.interview_date.to_s + time[10, time.length]
		#DateTime getting parsed in GMT. Hence manipulating string into IST.
		tempdatetime= DateTime.parse(dt).rfc3339
		datetime =  tempdatetime[0,tempdatetime.length-5]+"05:30"
		params= allow_params()
		interviewers= user["email"]

		event = {
			'summary'=> @schedule.summary,
			'description'=> @schedule.description,
			'start'=> {'dateTime' => datetime },
			'end' => {'dateTime' => datetime },
			'sendNotifications' => true,
				'attendees'=> [
			    {
			      'email'=> @schedule.candidate_details[:email],
			      'displayName'=> "Interviewee",
			    },
			  ] 			
		}

		interviewers.each do |interviewer|
			user= User.any_of(:email=>interviewer).to_a
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
		@schedule= Schedule.where(google_id: params[:id]).first
		p "Helloooooooo schedule"
		p @schedule.feedback["Amoolya Kumar"]
		p "Llllllllllllll"
		@event= CalendarApi.get_event(current_user, params[:id])
	end

	def edit
		@schedule= Schedule.where(google_id: params[:id]).first
		@emails = User.all.collect {|p| [p.email]}
	end

	def update
		user= params[:user]
		@schedule= Schedule.where(google_id: params[:id]).first
		@schedule.summary = (allow_params[:summary])
		@schedule.description = (allow_params[:description])
		@schedule.interview_date= (allow_params[:interview_date])
		@schedule.interview_time= (allow_params[:interview_time])
		@schedule.interview_type= (allow_params[:interview_type])
		@schedule.candidate_details= (allow_params[:candidate_details])
		@schedule.public_profile= (allow_params[:public_profile])

		time = @schedule.interview_time.to_s		

		#TimePicker returns today's date along with time. Hence manipulating string to take only time
		dt= @schedule.interview_date.to_s + time[10, time.length]
		#DateTime getting parsed in GMT. Hence manipulating string into IST.
		tempdatetime= DateTime.parse(dt).rfc3339
		datetime =  tempdatetime[0,tempdatetime.length-5]+"05:30"
		params= allow_params()
		interviewers= user["email"]
		event = {
			'summary'=> @schedule.summary,
			'description'=> @schedule.description,
			'start'=> {'dateTime' => datetime },
			'end' => {'dateTime' => datetime },
			'sendNotifications' => true,
			'reminders.useDefault' => true,
			'defaultReminders'=> [
    {
      'method'=> "email",
      'minutes'=> 1440
    }
  ],
  'notificationSettings'=> {
    'notifications'=> [
      {
        'type'=> 'eventCreation',
        'method'=> 'email'
      }
    ]
  },

				'attendees'=> [
			    {
			      'email'=> @schedule.candidate_details[:email],
			      'displayName'=> "Interviewee",
			    },
			  ] 			
		}

		interviewers.each do |interviewer|
			user= User.any_of(:email=>interviewer).to_a
			@schedule.users << user
			event["attendees"].push('email' => interviewer)
		end

		@schedule.save
		CalendarApi.update_event(current_user, @schedule.google_id, event)
    redirect_to schedules_path
	end

	def get_event_status

		@schedule= Schedule.find(params[:schedule_id])
		p params
		@schedule.status= (params[:status])
		@schedule.save
		p @schedule
		redirect_to schedules_path		
	end

	def event_status
		@schedule= Schedule.find(params[:schedule_id])		
	end

	def feedback
		p "Arrived Safely"
		p params[:google_id]
		p params[:attendee_email]
		p params[:comment]
		@schedule= Schedule.where(google_id: params[:google_id]).first

		 a
		@schedule.feedback[params["attendee_name"]]= params[:comment]	
		p "llll"
		p @schedule.feedback
		p "llll"
		p @schedule.save		
		p @schedule				 
		#CalendarApi.add_comment(current_user, params[:google_id], params[:attendee_email], params[:comment])
		redirect_to schedule_path(params[:google_id])
	end

  def allow_params
  	params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :interview_type, :google_id, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin])
  end

end
