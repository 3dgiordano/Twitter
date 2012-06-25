require_relative 'twitter_api'

class Twitter
  include TwitterAPI

  def get_trends(woeid=1)
     TwitterAPI.get_trends woeid
  end
  
  
end
