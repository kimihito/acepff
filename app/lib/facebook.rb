class Facebook
  def initialize
    @graph = Koala::Facebook::API.new(ENV['FACEBOOK_ACCESS_TOKEN'])
  end

  def post_calendar_schedule(event,type)
    start_time = DateTime.parse(event['start']['dateTime']).strftime('%Y-%m-%d %H:%M:%S')
    end_time = DateTime.parse(event['end']['dateTime']).strftime('%Y-%m-%d %H:%M:%S')
    @graph.put_object('me', 'feed', message: message_style(start_time, end_time, type))
  end

  private
  def message_style(start_time, end_time, type)
    case type
    when 'created' then
      suffix = 'にお仕事の予定が追加されました (๑˃̵ᴗ˂̵)وｶﾞﾝﾊﾞﾘﾏｽ'
    when 'updated' then
      suffix = 'にお仕事の予定が変更になりました'
    when 'deleted' then
      suffix = 'のお仕事の予定がなくなりました ｻﾞﾝﾈﾝ...（・ω・｀）'
    end
    "#{start_time} 〜 #{end_time} #{suffix}"
  end
end
