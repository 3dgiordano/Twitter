require "net/http"
require "json"

module TwitterAPI

  TWITTERAPI_BASE_URL = "api.twitter.com"

  def self.get_trends(woeid=1)
    raise ArgumentError, 'Argument is not numeric' unless woeid.respond_to?("to_int")
    get_http("/1/trends/#{woeid}")
  end

  def self.get_twits_for_trend(trend_query)
    get_twits_for_query(trend_query)
  end

  def self.get_twits_for_query(query)
    raise ArgumentError, 'Argument is not string' unless query.respond_to?("to_s")
    get_http("/search", "q=#{query}") 
  end

  def self.get_twit_by_id(twit_id)
    raise ArgumentError, 'Argument is not numeric' unless twit_id.respond_to?("to_int")
    get_http("/1/statuses/show", "id=#{twit_id}")
  end

  def self.get_user_information_by_id(user_id)
    raise ArgumentError, 'Argument is not numeric' unless user_id.respond_to?("to_int")
    get_http("/1/users/show", "id=#{user_id}")
  end

  private
  def self.get_http(entity, query='')
    raise ArgumentError, 'Entity argument is not string' unless entity.respond_to?("to_s")
    raise ArgumentError, 'Query argument  is not string' unless query.respond_to?("to_s")
 
    result = "" 
    begin
      response = Net::HTTP.get_response(TWITTERAPI_BASE_URL, "#{entity}.json?#{query}")
      case response
      when Net::HTTPSuccess then
        result = JSON.parse(response.body) 
      when Net::HTTPBadRequest then
        result = get_error(entity, query, response.message, 1003)
      else
        result = get_error(entity, query, response.message, response.code.to_i)
      end
    rescue JSON::ParserError => parse_error
      result = get_error(entity, query, "Parser error", 1000)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => http_error
      result = get_error(entity, query, http_error.message, 1001)
    rescue Exception => ex
      result = get_error(entity, query, "Unknow error:#{ex.message}", 1004)
    ensure
      return result
    end
  end

  private
  def self.get_error(entity, query, message, code)
    {"errors"=>[{"message"=>"#{TWITTERAPI_BASE_URL}#{entity}.json?#{query} : #{message}", "code"=>code}]}
  end

end

