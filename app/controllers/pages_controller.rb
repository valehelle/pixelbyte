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
  end
end
