require "net/http"
require "json"

module TwitterAPI
  def self.get_trends(woeid=1)
    get_http "/1/trends/#{woeid}"
  end

  def self.get_twits_for_trend(trend)
    get_http "/search", "q=#{trend}" 
  end

  def self.get_twit_by_id(twit_id)
    get_http "/1/statuses/show", "id=#{twit_id}"
  end

  def self.get_user_information_by_id(user_id)
    get_http "/1/users/show", "id=#{user_id}"
  end

  def self.get_http(entity,query='')
    response = Net::HTTP.get_response("api.twitter.com","#{entity}.json?#{query}")
    JSON.parse(response.body)
  end
end


