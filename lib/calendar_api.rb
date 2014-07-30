require 'google/api_client'
require 'client_builder'
require 'date.rb'

class CalendarApi

  def CalendarApi.establish(user)
    @client = ClientBuilder.get_client(user)
    @service = @client.discovered_api('calendar', 'v3')

  end

  def self.create_event(user,event)
    if (event['start']['dateTime'] >= DateTime.now)
      if (user.role=='HR')
        CalendarApi.establish(user)
        result = @client.execute(:api_method => @service.events.insert,
                      :parameters => {'calendarId' => 'primary'},
                      :body_object => event,
                      :headers => {'Content-Type' => 'application/json'})

      end
    end
    result
  end
  
  def self.get_event(user, id)  
    if (user.role== 'HR')
      CalendarApi.establish(user)
      result = @client.execute(:api_method => @service.events.get,
        :parameters => {'calendarId' => 'primary', 'eventId' => id})
    end

    if (result!= nil)
      res= result.data
    end
    res
  end

  def self.fetch_event(user,summary) 
    if (user.role== 'HR')
      CalendarApi.establish(user)
      result = @client.execute(:api_method => @service.events.list,
       :parameters => {'calendarId' => 'primary'}, )
      id= ""   
      result.data.items.each do |event|
        if (event["summary"]== summary)
          id = event["id"]
        end
      end
    end
    id
  end

  def self.delete_event(user, id)
    if (user.role== 'HR')      
      CalendarApi.establish(user)
      result = @client.execute(:api_method => @service.events.delete,
       :parameters => {'calendarId' => 'primary','eventId' => id},)
    end
  end

  def self.update_event(user,id,event)

      if (user.role== 'HR')
       CalendarApi.establish(user)
        result = @client.execute(:api_method => @service.events.update,
                        :parameters => {'calendarId' => 'primary', 'eventId' => id},
                        :body_object => event,
                        :headers => {'Content-Type' => 'application/json'})
      end

  end

  def self.get_date(date2, x, y, z)
    date = Date.strptime(date2, "%m/%d/%Y")
    time = DateTime.new(date.year, date.month, date.day, x, y, z, Time.now.zone).rfc3339
  end

  def self.list_events_between_dates(user, date2, date3)

    if (user.role== 'HR')
      CalendarApi.establish(user)
      time_min= CalendarApi.get_date(date2, 0, 0, 0)
      time_max= CalendarApi.get_date(date3, 23, 59, 59)
      result = @client.execute(:api_method => @service.events.list,
       :parameters => {'calendarId' => 'primary', 
      'timeMin' => time_min, 'timeMax' => time_max})
    end

    if (result!= nil)
      res= result.data
    end

    res
  end

  def self.list_events(user)
    if (user.role== 'HR')
  	  CalendarApi.establish(user)
      result = @client.execute(:api_method => @service.events.list,
       :parameters => {'calendarId' => 'primary'}, )
    
    if (result!= nil)
      res= result.data
    end
    end
    res
  end

  def self.calendar_list(user)
    if (user.role== 'HR')
      CalendarApi.establish(user)
      result = @client.execute(:api_method => @service.calendar_list.list)
    end
    if (result!= nil)
      res= result.data
    end
    res
  end

  def self.add_comment(user, event_id, attendee_email, comment)
    CalendarApi.establish(user)
    result = @client.execute(:api_method => @service.events.get, 
      :parameters => {'calendarId' => 'primary','eventId' => event_id},)

    result.data["attendees"].each do |result_attendee|
        if (result_attendee["email"]== attendee_email)
          result_attendee["comment"]= comment
        end
    update_event(user, event_id, result.data)
    end
  end

end