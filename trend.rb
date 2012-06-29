require_relative 'twitter_api'
require_relative 'twit'

class Trend

  attr_accessor :name, :query

  def initialize(name, query)
    @name = name
    @query = query
  end

  def get_twits
    result = []
    twits_api = TwitterAPI.get_twits_for_trend(@query)
    twits_api["results"].each{|t| result << Twit.new(t["id"]) }
    return result
  end

end
