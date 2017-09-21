class WebhookController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create
        puts "RECEIVE IT"
        @challange = 'WEEE'
        render plain: @challange
    end
    def index
        if request.GET['hub.verify_token'] == 'slakfmsalkdfjsadlsafdsadf' then
            @challange = request.GET['hub.challenge']
            puts @challange
            render plain: @challange
        end
       
    end
end
