require 'spec_helper'

describe CalendarApi do
	context "It should create events" do
		it "creates events if user is valid" do
		end

		it "redirects if user is invalid" do
		end
	end

	context "It should delete event" do
		it "deletes event if user is valid" do
		end

		it "redirects if user is not invalid" do
		end
	end

	context "It should update events" do
		it "updates events if user is invalid" do
		end

		it "redirects if user is not valid" do
		end

		it "updates attendees to a particular event" do
		end

		it "should be able to modify date of an event" do
		end

		it "should be able to modify time of an event" do
		end

	end

	context "It should LIST events" do
		it "should list ALL events on calendar" do
			let(:hr1) {FactoryGirl.create(:hr)}
			op = CalendarApi.list_events(:hr1).data
		end

		it "should list events by date" do
		end

		it "should list all events for a particular user" do
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