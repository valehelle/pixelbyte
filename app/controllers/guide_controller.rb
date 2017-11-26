class GuideController < ApplicationController
    def show
        page_id = params[:page_id]
        @current_tab = current_user.pages.find_by(id: page_id)
        @tabs = current_user.pages
    end
end
