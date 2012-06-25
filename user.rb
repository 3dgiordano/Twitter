
class User

  attr_accessor :id, :screen_name, :name, :followers_count, :user_response

  def initialize(id)
    @id = id
    @user_response = TwitterAPI.get_user_information_by_id(id)
  end

  def id
    @id
  end 

  def screen_name
    @screen_name = @user_response["screen_name"] if @screen_name.nil?
    return @screen_name
  end

  def name
    @name = @user_response["name"] if @name.nil?
    return @name
  end

  def followers_count
    @followers_count = @user_response["followers_count"] if @followers_count.nil?
    return @followers_count
  end

end
