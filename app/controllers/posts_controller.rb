class PostsController < ApplicationController
    def index
    end
    def show
        page_id = params[:page_id]
        post_id = params[:post_id]
        @current_tab = current_user.pages.find_by(id: page_id)
        @tabs = current_user.pages

        @post = @current_tab.posts.find_by(id: post_id)
        
    end
end
