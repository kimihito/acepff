class NotificationsController < ApplicationController
  skip_before_action :verify_authentication_token

  def index
  end

  def receive
    # push notificationを受け取り、変更されたイベントを取得
    # その後、Facebookに投稿する。
    # 文言はイベントのステータスによって変更される

    cal = Calendar.new
    cal.create_channel
    recent_update_events = cal.get_events
    recent_update_events.each do |event|
      e = Event.where(code: event['id'])
      if e.empty?
        # 新しく追加されたイベントの処理
        Event.create(code: event['id'])
        type = 'created'
      else
        # キャンセルだった場合
        type = 'updated'
        if event['status'] == 'cancelled'
          type = 'deleted'
          e.destroy
        end
      end
      fb = Facebook.new
      fb.post_calendar_schedule(event, type)
    end
  end
end
