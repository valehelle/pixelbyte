class WebhookController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create
        @hash = request.POST['webhook']
        @entries = @hash['entry']
        @entries.each do |entry|
            @changes = entry['changes']
            @changes.each do |change|
                if change['field'] == 'feed' then
                    @value = change['value']
                    if @value['item'] == 'comment' then
                        message = @value['message']
                        page_id = @value['parent_id'].to_s.split('_')[0]
                        sender_name = @value['sender_name']
                        page = Page.find_by(page_id: page_id)
                        if page then
                            post_id = @value['post_id']
                            post = page.posts.find_by(post_id: post_id)
                            if post then
                                if isKeyword(message,post.keyword) then
                                    page_graph = Koala::Facebook::API.new(page.access_token)
                                    comment_id = @value['comment_id']
                                    if post.is_reply
                                        message = post.reply_content
                                        message = message.gsub(/@user/, sender_name)  
                                        if !message.nil? && message.length > 0
                                            page_graph.put_comment(comment_id, message)
                                        end                           
                                    end
                                    if post.is_private_message
                                        message = post.private_message_content
                                        message = message.gsub(/@user/, sender_name)
                                        if !message.nil? && message.length > 0
                                            page_graph.put_connections(comment_id, "private_replies", :message=> message)
                                        end       
                                    end
                                end                    
                            end
                        end
                    end
                end                    
            end
        end
        @plain = 'success'
        render plain: @plain
    end
    def index
        if request.GET['hub.verify_token'] == 'slakfmsalkdfjsadlsafdsadf' then
            @challange = request.GET['hub.challenge']
            puts @challange
            render plain: @challange
        end
    end

    def isKeyword(message,keyword)
        isKeyword = false
        if !keyword.nil? && keyword.length > 0 then
            keywords = keyword.split(',')
            
            keywords.each do |keyword|
                if message.upcase == keyword.upcase
                    isKeyword = true
                end
            end
            
        else
            isKeyword = false
        end

        return isKeyword
    end
end
