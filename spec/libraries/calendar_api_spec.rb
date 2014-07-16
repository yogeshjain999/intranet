require 'spec_helper'

describe CalendarApi do
	context "It should create events" do

		it "returns nil if user is invalid" do
	event = {
			'summary'=> "Silly Event",
			'start'=> {'dateTime' => "2011-06-03T10:00:00.000-07:00" },
		}
			hr1 = FactoryGirl.create(:user)
	    op = CalendarApi.create_event(hr1, event)
	    (op).should eq(nil)
		end

		it "returns nil if event does not have a summary" do
			event = {'location' => 'l1', 
							'start'=> {'dateTime' => "2011-06-03T10:00:00.000-07:00" },}
			hr1 = FactoryGirl.create(:user)
	    op = CalendarApi.create_event(hr1, event)
	    (op).should eq(nil)
		end

		it "returns nil if event is outdated" do
			event = {
			'summary'=> "Silly Event",
			'start'=> {'dateTime' => "2011-06-03T10:00:00.000-07:00" },
		}
  		hr1 = FactoryGirl.create(:hr)
  		id = ""
  		op = CalendarApi.create_event(hr1, event)
	    (op).should eq(nil)
		end
	end

	context "It should delete event" do

		it "returns nil user is invalid" do
			id= ""
			event= {'summary' => 'E1'}
			hr1 = FactoryGirl.create(:user)
	    op = CalendarApi.delete_event(hr1, id)
	    (op).should eq(nil)
		end
	end

	context "It should update events" do

		it "returns nil if user is not valid" do
			id = ""
		event = {
			'summary'=> "Silly Event",
			'start'=> {'dateTime' => "2011-06-03T10:00:00.000-07:00" },
		}
			hr1 = FactoryGirl.create(:user)
	    op = CalendarApi.update_event(hr1, id, event)
	    (op).should eq(nil)
		end

		it "returns nil if the event is outdated" do
			event = {
			'summary'=> "Silly Event",
			'start'=> {'dateTime' => "2011-06-03T10:00:00.000-07:00" },
		}
  		hr1 = FactoryGirl.create(:hr)
  		id = ""
  		op = CalendarApi.update_event(hr1, id, event)
	    (op).should eq(nil)
		end
	end

	context "It should LIST events" do
		it "returns nil if the user is invalid" do
	    hr1 = FactoryGirl.create(:user)
	    op = CalendarApi.list_events(hr1)
	    (op).should eq(nil)
		end
	end

	context "It should LIST attendees" do
		it "should list ALL attendees to a particular event" do
		end
	end

	context "It should SHOW event" do
		it "should fetch response of an attendee to an event" do
		end

		it "should fetch status of an event (confirmed, tentative, cancelled)" do
		end

		it "should fetch summary of an event" do
		end

		it "should fetch description of an event " do
	  end

	  it "should fetch start-date of an event" do
	  end

	  it "should fetch time of an event" do
	  end
	end

	it "should set transparency for an event: opaque or transparent" do
	end

	it "should send retrieve a link to this event in the Google Calendar Web UI" do
	end

	it "should check for invalid attendees' email ids" do
	end

end