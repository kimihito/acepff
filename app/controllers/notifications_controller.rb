class NotificationsController < ApplicationController
  skip_before_action :verify_authentication_token

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
        new_event = Event.create(code: event['id'])
      else
        # キャンセルだった場合
        if event['status'] == 'cancelled'
          e.destroy
        end
      end
    end
  end
end
