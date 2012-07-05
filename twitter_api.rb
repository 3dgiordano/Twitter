require "net/http"
require "json"

module TwitterAPI

  TWITTERAPI_BASE_URL = "api.twitter.com"

  def self.get_trends(woeid=1)
    raise ArgumentError, 'Argument is not numeric' unless woeid.is_a? Numeric
    get_http "/1/trends/#{woeid}"
  end

  def self.get_twits_for_trend(trend_query)
    raise ArgumentError, 'Argument is not string' unless trend_query.is_a? String
    get_http "/search", "q=#{trend_query}" 
  end

  def self.get_twit_by_id(twit_id)
    raise ArgumentError, 'Argument is not numeric' unless twit_id.is_a? Numeric
    get_http "/1/statuses/show", "id=#{twit_id}"
  end

  def self.get_user_information_by_id(user_id)
    raise ArgumentError, 'Argument is not numeric' unless user_id.is_a? Numeric
    get_http "/1/users/show", "id=#{user_id}"
  end

  private
  def self.get_http(entity,query='')
    raise ArgumentError, 'Entity argument is not string' unless entity.is_a? String
    raise ArgumentError, 'Query argument  is not string' unless query.is_a? String
    result = "" 
    begin
      response = Net::HTTP.get_response(TWITTERAPI_BASE_URL,"#{entity}.json?#{query}")
      case response
      when Net::HTTPSuccess then
        result = JSON.parse(response.body) 
      when Net::HTTPBadRequest then
        result = {"errors"=>[{"message"=>"#{TWITTERAPI_BASE_URL}#{entity}.json?#{query} : #{response.message}", "code"=>1003}]}
      else
        result = {"errors"=>[{"message"=>"#{TWITTERAPI_BASE_URL}#{entity}.json?#{query} : #{response.message}", "code"=>response.code.to_i}]}
      end
    rescue JSON::ParserError => parse_error
      result = {"errors"=>[{"message"=>"Parser error", "code"=>1000}]}
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => http_error
      result = {"errors"=>[{"message"=>"#{TWITTERAPI_BASE_URL}#{entity}.json?#{query} : #{http_error.message}", "code"=>1001}]}
    ensure
      return result
    end
  end

end


