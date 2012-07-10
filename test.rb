require 'test/unit'

require_relative 'twitter_crawler'
require_relative 'utils'
require_relative 'twitter'

class TestTwitter < Test::Unit::TestCase

  # TwitterAPI Trends
  def test_twitter_api_trends_argument_error
    assert_raise ArgumentError do
      TwitterAPI.get_trends("String Argument")
    end
  end

  def test_twitter_api_trends_result
    assert TwitterAPI.get_trends[0]["trends"].length > 0
  end

  def test_twitter_api_trends_not_found
    assert TwitterAPI.get_trends(-1)["errors"][0]["code"] == 404
  end
  
  # TwitterAPI Twitts
  def test_twitter_api_twits_for_trend_result
    assert TwitterAPI.get_twits_for_trend("Jackson").length > 0
  end
  
  def test_twitter_api_twits_for_trend_not_found
    assert TwitterAPI.get_twits_for_trend("asdfg1234hjklmnbvcxzq4556wertyuiop")["results"].length == 0
  end
  
  # TwitterAPI Twitt by ID
  def test_twitter_api_twit_by_id_argument_error
    assert_raise ArgumentError do
      TwitterAPI.get_twit_by_id("id")
    end
  end
  
  def test_twitter_api_twit_by_id_result
    assert TwitterAPI.get_twit_by_id(220289460208799745)["id"] == 220289460208799745
  end
  
  def test_twitter_api_twit_by_id_not_found
    assert TwitterAPI.get_twit_by_id(111111111111111)["errors"][0]["code"] == 404
  end
  
  # TwitterAPI User information by ID
  def test_twitter_api_user_information_by_id_argument_error
    assert_raise ArgumentError do
      TwitterAPI.get_user_information_by_id("id")
    end
  end
  
  def test_twitter_api_user_information_by_id_result
    assert TwitterAPI.get_user_information_by_id(18899974)["id"] == 18899974
  end
  
  def test_twitter_api_user_information_by_id_not_found
    assert TwitterAPI.get_user_information_by_id(-100)["errors"][0]["code"] == 404
  end

  # Twitter class
  def test_twitter_class_get_trends
    twitter = Twitter.new
    trends = twitter.get_trends
    if trends.length > 0
        assert trends[0].is_a? Trend 
    else
        assert false, "Trends not found!"
    end
  end

  # Trend class
  def test_trend_class_get_twits
    trend = Trend.new("Test","Jackson","")
    twits = trend.get_twits
    if twits.length > 0
        assert twits[0].is_a? Twit 
    else
        assert false, "Twits not found!"
    end
  end

  # Twit class
  def test_twit_class_get_user
    twit = Twit.new(220289460208799745)
    user = twit.get_user
    assert user.is_a? User
  end

  def test_twit_class_notfound
    assert_raise TypeError do
        twit = Twit.new(220289460208799745111111111)
    end
  end
  
end
