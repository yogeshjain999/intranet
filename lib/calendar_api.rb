require 'google/api_client'
require 'client_builder'
require 'date.rb'

class CalendarApi

  def self.create_event(user,event)
    p "DODO"
      if (user.role=='HR')
        p "Dracula"
        client = ClientBuilder.get_client(user)
        service = client.discovered_api('calendar', 'v3')
        result = client.execute(:api_method => service.events.insert,
                      :parameters => {'calendarId' => 'primary'},
                      :body_object => event,
                      :headers => {'Content-Type' => 'application/json'})
       
      end
  
  end
  
  def self.get_event(user, id)  
    if (user.role== 'HR')
      client = ClientBuilder.get_client(user)
      service = client.discovered_api('calendar', 'v3')
      result = client.execute(:api_method => service.events.get,
        :parameters => {'calendarId' => 'primary', 'eventId' => id})
    end

    if (result!= nil)
      res= result.data
    end
    res
  end

  def self.fetch_event(user,summary) 
    if (user.role== 'HR')
      client = ClientBuilder.get_client(user)
      service = client.discovered_api('calendar', 'v3')
      result = client.execute(:api_method => service.events.list,
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
      client = ClientBuilder.get_client(user)
      service = client.discovered_api('calendar', 'v3')
      result = client.execute(:api_method => service.events.delete,
       :parameters => {'calendarId' => 'primary','eventId' => id},)
    end
  end

  def self.update_event(user,id,event)
       
      if (user.role== 'HR')
        client = ClientBuilder.get_client(user)
        service = client.discovered_api('calendar', 'v3')
        result = client.execute(:api_method => service.events.get,
          :parameters => {'calendarId' => 'primary','eventId' => id},)
        result = client.execute(:api_method => service.events.update,
          :parameters => {'calendarId' => 'primary', 'eventId' => id}, 
          :body_object => event,
          :headers => {'Content-Type' => 'application/json'},)
      end
  end

  def self.list_events_by_date(user, date2)
    res= ""
  
    if (user.role== 'HR')
      client = ClientBuilder.get_client(user)
      date = Date.strptime(date2, "%m/%d/%Y")
      dt = DateTime.new(date.year, date.month, date.day, 0, 0, 0, Time.now.zone)

      time_min = DateTime.parse(dt.strftime()).rfc3339
      dt = DateTime.new(date.year, date.month, date.day, 23, 59,59 , Time.now.zone)
      time_max = DateTime.parse(dt.strftime()).rfc3339
p "min time"
p time_min
p "max time"
p time_max
      service = client.discovered_api('calendar', 'v3')
      result = client.execute(:api_method => service.events.list,
       :parameters => {'calendarId' => 'primary', 
      'timeMin' => time_min, 'timeMax' => time_max})
    end

    if (result!= nil)
      res= result.data
    end
    res
  end

  def self.list_events(user)
    res= ""
    if (user.role== 'HR')
  	  client = ClientBuilder.get_client(user)

      service = client.discovered_api('calendar', 'v3')
      result = client.execute(:api_method => service.events.list,
       :parameters => {'calendarId' => 'primary'}, )
    end
    if (result!= nil)
      res= result.data
    end
    res
  end

  def self.calendar_list(user)
    if (user.role== 'HR')
      client = ClientBuilder.get_client(user)
      service = client.discovered_api('calendar', 'v3')
      result = client.execute(:api_method => service.calendar_list.list)
    end
    if (result!= nil)
      res= result.data
    end
    res
  end

end