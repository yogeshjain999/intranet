require 'google/api_client'

class ClientBuilder
  KEY_FILE = "#{Rails.root}/config/service_account_key.p12"
  KEY_SECRET = 'notasecret'
  SERVICE_ACC_EMAIL = '1099029398199-8eqlk4fv565gt9qas0ohc094ui5ovq4t@developer.gserviceaccount.com'

  def self.build_client
    @key = Google::APIClient::KeyUtils.load_from_pkcs12(KEY_FILE, KEY_SECRET)
    @client = Google::APIClient.new application_name: "Intranet", application_version: "0.0.1"
    authorize_client
    @client.authorization.fetch_access_token!
    @client
  end

  def self.authorize_client
    @client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/calendar',
      :issuer => SERVICE_ACC_EMAIL,
      :grant_type => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      :access_type => 'offline',
      :signing_key => @key
    )
  end
end
