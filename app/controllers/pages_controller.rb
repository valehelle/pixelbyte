class PagesController < ApplicationController
  before_action :authenticate_user!, :facebook_expiry

  def index
    @graph = Koala::Facebook::API.new(current_user.access_token)
    begin
      pages = @graph.get_connections('me', 'accounts')
      puts pages
      
    rescue Koala::Facebook::AuthenticationError => e # Never do this!
      redirect_to user_facebook_omniauth_authorize_path and return
    end
    
    pages.each do |page|

      name =  page['name']
      access_token = page['access_token']
      page_id = page['id']
      permission = false
      perms = page['perms']
      perms.each do |perm|
      if perm == 'ADMINISTER'
          permission = true
        end
      end

      page = current_user.pages.where(page_id: page_id).first()
      if page.nil?
        page = current_user.pages.build(name: name, access_token: access_token, is_admin: permission, page_id: page_id)
      else
        page.name = name
        page.access_token = access_token
        page.is_admin = permission
        page.page_id = page_id
      end
      page.save!
    end
    @tabs = current_user.pages

    @current_tab = @tabs.first()
    redirect_to page_path(@current_tab)
  end

  def show
    id = params[:id]
    @current_tab = current_user.pages.find_by(id: id)
    page_graph = Koala::Facebook::API.new(@current_tab.access_token)
    @page = page_graph.get_object('me?fields=feed,picture,is_webhooks_subscribed')
    feeds = @page['feed']['data']
    is_page_subscribed = @page['is_webhooks_subscribed']
    
    image = @page['picture']['data']['url']
    @current_tab.image = image
    @current_tab.save!
    
    if !is_page_subscribed
      require "uri"
      require "net/http"

      params = {'access_token' => @current_tab.access_token}
      x = Net::HTTP.post_form(URI.parse('https://graph.facebook.com/v2.10/' + @current_tab.page_id + '/subscribed_apps'), params)
    end

    feeds.each do |post|
      post_id = post['id']
      message = post['message']
      created_time = post['created_time']
      if @current_tab.posts.find_by(post_id: post_id).blank?
        post = @current_tab.posts.build(post_id: post_id, content: message, is_reply: false, is_private_message: false,created_time: created_time)
        post.save
      end
    end
    @posts = @current_tab.posts.reverse_order
    @tabs = current_user.pages
  end
end
