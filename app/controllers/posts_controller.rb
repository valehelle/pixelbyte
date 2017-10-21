class PostsController < ApplicationController
    before_action :authenticate_user!
    def index
    end
    def show
        page_id = params[:page_id]
        post_id = params[:post_id]
        @current_tab = current_user.pages.find_by(id: page_id)
        @tabs = current_user.pages

        @post = @current_tab.posts.find_by(id: post_id)
        
    end
    def update
        page_id = params[:page_id]
        post_id = params[:post_id]
        @current_tab = current_user.pages.find_by(id: page_id)
        puts @current_tab
        @post = @current_tab.posts.find_by(id: post_id)
        
        if @post.update_attributes(post_params)
            redirect_to post_path, :notice => "Your post have been updated"
        else
            render "show"
        end
    end

    private
        def post_params
            params.require(:post).permit(:is_private_message, :private_message_content, :is_reply, :reply_content)
        end
end
