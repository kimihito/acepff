require 'google/api_client'

class Calendar
  def initialize
    @client = Google::APIClient.new
    @client.authorization.client_id = ENV['CLIENT_ID']
    @client.authorization.client_secret = ENV['CLIENT_SECRET']
    @client.authorization.refresh_token = ENV['REFRESH_TOKEN']
    @client.authorization.fetch_access_token!
  end

  def create_channel
    service = @client.discovered_api('calendar', 'v3')
    @client.execute!(
      api_method: service.events.watch,
      parameters: { calendarId: ENV['CALENDAR_ID'] },
      body_object: {
        id: SecureRandom.uuid(),
        type: 'web_hook',
        address: ENV['RECEIVE_URL']
      })
  end
end
