require 'google/api_client'

class ClientBuilder

  def self.get_client(user)
    client = Google::APIClient.new
    client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
    client.authorization.access_token = get_current_token(user)
    client
  end

  def self.get_current_token(user)
      if (user.access_token.nil? || (user.expires_at.nil? || user.expires_at <Time.now.to_i))
      
=begin  
        conn = Faraday.new(:url => 'https://accounts.google.com/o/oauth2/token')
        conn.post 'https://accounts.google.com/o/oauth2/token',
         { :client_id => GOOGLE_APP_ID, 
           :client_secret => GOOGLE_APP_SECRET,
           :refresh_token => user.refresh_token,
           :grant_type => refresh_token }

        conn.get 'https://accounts.google.com/o/oauth2/token',
        {
          :access_token
        }

        user.
=end
      client = OAuth2::Client.new(
            :client_id => GOOGLE_APP_ID, 
            :client_secret => GOOGLE_APP_SECRET,
                    :site => "https://accounts.google.com",
                    :token_url => "/o/oauth2/token",
                    :authorize_url => "/o/oauth2/auth"
                    )
      access_token = OAuth2::AccessToken.from_hash(client,
            {:refresh_token => user.refresh_token})

        access_token = access_token.refresh!
        user.access_token = access_token.token
        user.expires_at = Time.now + access_token.expires_in
        user.save

      end
      user.access_token
  end
end