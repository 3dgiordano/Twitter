require_relative 'twitter_api'
require_relative 'twit'

class Trend

  attr_accessor :name, :query, :as_of

  def initialize(name, query, as_of)
    @name = name
    @query = query
    @as_of = as_of
  end

  def get_twits
    result = []
    twits_api = TwitterAPI.get_twits_for_trend(@query)
    return result if twits_api.include?("errors")
    twits_api["results"].each{|t| result << Twit.new(t["id"]) }
    result
  end

end
