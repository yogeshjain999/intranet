require 'net/http'
module Api
  class Bonusly

    def initialize(options = {})
      defaults = {
        size: 100
      }.merge(options)
      @no_of_users = options[:size]
      @uri = URI.parse('https://bonus.ly/api/v1/bonuses/month')
      @token = "06377121edd7d8867e7d8998968d7f6e"
      get_request
      initialize_data_size
    end

    def get_request
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.get(@uri.path+"?access_token=#{@token}")
      @data = JSON.parse(response.body)
    end

    def get_bonusly_data
      @data.take(@no_of_users)
    end
    
    def initialize_data_size
      @data = get_bonusly_data  
    end

    def all_bonusly_messages
      messages = []
      @data.each { |d| messages << self.bonusly_message_for(d) }
      messages
    end

    def bonusly_message_for(m, options = {})
      "#{m["receiver"]["name"]} got #{m["amount"]} bonus from #{m["giver"]["name"]} for #{m["reason"]} in #{m["value"]}"
    end

    {"created_at"=>"2013-10-29T15:13:00Z", "reason"=>"helping out...", "amount"=>300, "value"=>"problem solving", "giver"=>{"name"=>"aditya shedge", "email"=>"aditya@joshsoftware.com", "path"=>"/company/users/526e500c9b6dab1c8d000001", "full_pic_url"=>"/assets/noPic_80.png", "profile_pic_url"=>"/assets/noPic_80.png", "small_pic_url"=>"/assets/noPic_80.png", "picture_url"=>"/assets/noPic_80.png", "first_name"=>"aditya", "last_name"=>"shedge"}, "receiver"=>{"name"=>"Shailesh", "email"=>"shailesh@joshsoftware.com", "path"=>"/company/users/5255067e2d88acd7be000001", "full_pic_url"=>"/assets/noPic_80.png", "profile_pic_url"=>"/assets/noPic_80.png", "small_pic_url"=>"/assets/noPic_80.png", "picture_url"=>"/assets/noPic_80.png", "first_name"=>nil, "last_name"=>nil}}
  end
end
