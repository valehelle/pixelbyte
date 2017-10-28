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
                                        if !message.nil? && message.length > 0
                                            page_graph.put_comment(comment_id, message)
                                        end                           
                                    end
                                    if post.is_private_message
                                        message = post.private_message_content
                                        if !message.nil? && message.length > 0
                                            page_graph.put_connections(comment_id, "private_replies", :message=> message)
                                        end       
                                    end
                                end                    
                            end

                           
                        end
                        if message && message.upcase == 'PM' then
                            @sender_name = @value['sender_name']
                            @comment_id = @value['comment_id']
                            @data = {message: 'Hello' + @sender_name}
                            @access_token = 'EAABsvY2CRNMBAAXbZBZBj1fvAvqZBifZCMdlpHP1ImMLU2ZAXvqjBirFNn13Qva3arxBHwIFgc9HFxJqORS0cIvNTiwThkoB7dq2vgdujJNbntKnZApjYTWfz5wOyKa6L4pzq5fRF0nZCpZCZCkzsSU9JuHVo9vZBZAcLHyawH6dG31ZAgZDZD'
                            require 'net/http'
                            require 'uri'
                            require 'json'
                            @url = 'https://graph.facebook.com/' + @comment_id + '/private_replies?access_token=' + @access_token


                            request = Typhoeus::Request.new(
                                @url,
                                method: :post,
                                body: "this is a request body",
                                params: { message: "Hi " + @sender_name + ". Ini adalah mesej automatik dari Pixie. Sila click link ini untuk mengetahui dengan lebih lanjut. www.pixelbyte.gq" },
                                headers: { Accept: "text/html" }
                                ).run
                            
                            @urlcomment = 'https://graph.facebook.com/' + @comment_id + '/comments?access_token=' + @access_token


                            request = Typhoeus::Request.new(
                                @urlcomment,
                                method: :post,
                                body: "this is a request body",
                                params: { message: 'Hi, ' + @sender_name + '. Nama saya Pixie, pembantu Facebook automatik anda. Komen ini telah dibalas secara automatik. Saya telah PM anda jika anda ingin mengetahui dengan lebih lanjut.'},
                                headers: { Accept: "text/html" }
                                ).run   
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
