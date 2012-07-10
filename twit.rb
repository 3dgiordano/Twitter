require_relative 'twitter_api'
require_relative 'utils'
require_relative 'user'

class Twit

  attr_accessor :id, :text, :user_id, :created_at, :links

  def initialize(id)
    @id = id
    get_data
  end
  
  def get_user
     User.new(@user_id)
  end

  def refresh
    get_data
  end

  private
  def get_data
    twit_response = TwitterAPI.get_twit_by_id(@id)
    raise twit_response if twit_response.include?("errors")
    @text = twit_response["text"]
    @user_id = twit_response["user"]["id"]
    @created_at = twit_response["created_at"]
    @links = get_links(@text)
  end

end
