require_relative 'twitter_api'

class User

  attr_accessor :id, :screen_name, :name, :followers_count

  def initialize(id)
    @id = id
    get_data
  end

  def refresh
    get_data
  end

  private
  def get_data
    user_response = TwitterAPI.get_user_information_by_id(@id)
    @screen_name = user_response["screen_name"]
    @name = user_response["name"]
    @followers_count = user_response["followers_count"]
  end

end
