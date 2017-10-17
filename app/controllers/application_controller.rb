class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    @graph = Koala::Facebook::API.new(current_user.access_token)
    pages = @graph.get_connections('me', 'accounts')
    puts pages.first()
    puts 'HELOOO'
  end

end
