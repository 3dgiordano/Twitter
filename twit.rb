require_relative 'utils'
require_relative 'user'

class Twit

  attr_accessor :id, :text, :user_id, :created_at, :twit_response, :links

  def initialize(id)
    @id = id
    @twit_response = TwitterAPI.get_twit_by_id(id)
  end

  def text
    @text = @twit_response["text"] if @text.nil?
    return @text
  end
  
  def user_id
    @user_id = @twit_response["user"]["id"] if @user_id.nil?
    return @user_id
  end

  def created_at
    @created_at = @twit_response["created_at"] if @created_at.nil?
    return @created_at
  end

  def links
    @links = get_links(self.text) if @links.nil?
    return @links
  end

  def get_user
     User.new(self.user_id)
  end
end
