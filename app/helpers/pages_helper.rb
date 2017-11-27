module PagesHelper
  def get_time(time)
    if(!time.nil?)
      seconds = (Time.now - time)
      if seconds > 259200 then
          time.strftime("%B %d, %Y")
      else
          time_ago_in_words(time) + ' ago'
      end
    end
  end
end
