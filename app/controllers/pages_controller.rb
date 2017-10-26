class PagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @graph = Koala::Facebook::API.new(current_user.access_token)
    pages = @graph.get_connections('me', 'accounts')
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
        puts "empty"
        page = current_user.pages.build(name: name, access_token: access_token, is_admin: permission, page_id: page_id)
      else
        puts "Not empty"
        page.name = name
        page.access_token = access_token
        page.is_admin = permission
        page.page_id = page_id
      end
      page.save
     
    end
    @tabs = current_user.pages
    @current_tab = @tabs.first()
    redirect_to page_path(@current_tab)
  end

  def show
    id = params[:id]
    @current_tab = current_user.pages.find_by(id: id)
    page_graph = Koala::Facebook::API.new(@current_tab.access_token)
    @feeds = page_graph.get_connection('me', 'feed')
    webhook = Koala::Facebook::API.new(@current_tab.access_token).get_object(:me, { fields: [:is_webhooks_subscribed]})
    is_page_subscribed = webhook['is_webhooks_subscribed']
    
    if !is_page_subscribed
      require "uri"
      require "net/http"

      params = {'access_token' => @current_tab.access_token
      }
      x = Net::HTTP.post_form(URI.parse('https://graph.facebook.com/v2.10/' + @current_tab.page_id + '/subscribed_apps'), params)
    end

    @feeds.each do |post|
      post_id = post['id']
      message = post['message']
      if @current_tab.posts.find_by(post_id: post_id).blank?
        post = @current_tab.posts.build(post_id: post_id, content: message, is_reply: false, is_private_message: false)
        post.save
        puts 'save post'
      end
    end
    @posts = @current_tab.posts
    @tabs = current_user.pages
  end
end
