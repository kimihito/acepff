require 'google/api_client'

class Calendar
  def initialize
    @client = Google::APIClient.new
    @client.authorization.client_id = ENV['CLIENT_ID']
    @client.authorization.client_secret = ENV['CLIENT_SECRET']
    @client.authorization.refresh_token = ENV['REFRESH_TOKEN']
    @client.authorization.fetch_access_token!
    @service = @client.discovered_api('calendar', 'v3')
  end

  def create_channel
    # Push通知を送るためのチャンネルを作成する。
    @client.execute!(
      api_method: @service.events.watch,
      parameters: { calendarId: ENV['CALENDAR_ID'] },
      body_object: {
        id: SecureRandom.uuid(),
        type: 'web_hook',
        address: ENV['RECEIVE_URL']
      })
  end

  def get_events
    # 更新された予定を取得する
    response = @client.execute!(
      api_method: @service.events.list,
      parameters: {
        calendarId: ENV['CALENDAR_ID'],
        updatedMin: 1.minutes.ago.to_datetime.rfc3339
      }
    ).response.body
    JSON.parse(response)['items']
  end
end
