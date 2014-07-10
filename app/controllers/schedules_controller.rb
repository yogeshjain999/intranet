require 'calendar_api.rb'
require 'date.rb'

class SchedulesController < ApplicationController

	def index
		p "I AM HERE AMMU"
		@events= CalendarApi.list_events(current_user)
	end

	def new
		@schedule= Schedule.new
	end

	def create
		@schedule= Schedule.new(allow_params)
		@schedule.save
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
			event["attendees"].push('email' => interviewer)
		end
		CalendarApi.create_event(current_user, event)
    redirect_to schedules_path
	end

	def destroy
		CalendarApi.delete_event(current_user, params[:id])
		redirect_to schedules_path
	end

	def show
		@event= CalendarApi.get_event(current_user, params[:id])
	end

	def edit
		@schedule= Schedule.find(params[:id])
	end

	def update
		@schedule= Schedule.new()
		@schedule.save
	end

  def allow_params
  	puts	params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :interview_type, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin], users_attributes: [:email => []])
 
 
  	params.require(:schedule).permit(:summary, :description, :interview_date, :interview_time, :interview_type, candidate_details: [:name, :email, :telephone, :skype_id], public_profile: [:git, :linkedin], users_attributes: [ :_id, :email => []])
  end
end
