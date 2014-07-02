require 'google/api_client'
require 'client_builder'

class CalendarApi

  def self.create_event(user,event)
    if (event['start']['date']== nil || Date.parse(event['start']['date']) > Date.today)
      if (user.role=='HR')

        client = ClientBuilder.get_client(user)
        service = client.discovered_api('calendar', 'v3')
        result = client.execute(:api_method => service.events.insert,
                      :parameters => {'calendarId' => 'primary'},
                      :body_object => event,
                      :headers => {'Content-Type' => 'application/json'})
      end
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
    if (event['start']['date']== nil || Date.parse(event['start']['date']) > Date.today)    
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