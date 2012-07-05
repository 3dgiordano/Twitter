require_relative 'twitter_api'
require_relative 'trend'

class Twitter
  include TwitterAPI

  def get_trends(woeid=1)
    raise ArgumentError, 'Argument is not numeric' unless woeid.is_a? Numeric
    result = []
    trends_api = TwitterAPI.get_trends woeid
    return result if trends_api.include?("errors")
    trends_api.each{|e| e["trends"].each{|t| result << Trend.new(t["name"],t["query"]) } }
    return result
  end

end
