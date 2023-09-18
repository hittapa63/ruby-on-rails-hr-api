class SlackService::Channel < SlackService::Base
    def initialize(data:, action_name:)            
        @data = data
        @action_name = action_name
        super()
    end

    def call
        @client = Slack::Web::Client.new
        case @action_name
        when "channel_create"
            @data = channel_create
        when "channel_add_user"
            @data = channel_add_user
        when "post_message"
            @data = post_message
        else
          puts "no action in slack user service"
        end
        return @data
    end

    private

    def channel_create
        begin
            result = @client.conversations_create(name: @data[:channel_name], is_private: @data[:is_private].nil? ? true : @data[:is_private])
            result = result.channel
            return result
        rescue Exception => e
            result = e.error
            return result
        end
    end

    def channel_add_user
        puts "🧵🧵🧵🧵🧵🧵 channel add user 🧵🧵🧵🧵🧵"
        puts @data[:user].slack_id
        begin
            result = @client.conversations_invite(channel: @data[:channel_name], users: @data[:user].slack_id)
            result = result.channel
            return result
        rescue Exception => e
            puts e
            result = e
            return result
        end
    end

    def post_message
        begin
            # @client.chat_postMessage(channel: @data[:channel_name], blocks: @data[:blocks], as_user: false, username: 'WelcomeHomes Bot', icon_url: 'http://lorempixel.com/48/48/')
            @client.chat_postMessage(channel: @data[:channel_name], blocks: @data[:blocks], as_user: true)
        rescue Exception => e
            puts e
        end
    end
end