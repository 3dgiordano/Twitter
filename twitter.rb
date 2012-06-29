require_relative 'twitter_api'
require_relative 'trend'

class Twitter
  include TwitterAPI

  def get_trends(woeid=1)
     result = []
     trends_api = TwitterAPI.get_trends woeid
     trends_api.each{|e| e["trends"].each{|t| result << Trend.new(t["name"],t["query"]) } }
     return result
  end
  
  
end
