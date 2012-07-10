require_relative 'twitter_api'
require_relative 'trend'

class Twitter

  def get_trends(woeid=1)
    result = []
    trends_api = TwitterAPI.get_trends(woeid)
    return result if trends_api.include?("errors")
    trends_api.each{|e| e["trends"].each{|t| result << Trend.new(t["name"], t["query"], e["as_of"]) } }
    return result
  end

end
