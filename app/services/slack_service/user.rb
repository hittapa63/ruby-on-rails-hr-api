class SlackService::User < SlackService::Base    
    def initialize(data:, action_name:)          
        @team_id= ENV['SLACK_ID']
        @data = data
        @action_name = action_name
        super()
    end

    def call
        @client = Slack::Web::Client.new
        case @action_name
        when "users_invite"
          @data = users_invite
        when "users_list"
          @data = users_list
        when "users_conversation_open"
          @data = users_conversation_open
        else
          puts "no action in slack user service"
        end
        return @data
        self
    end

    private
    def users_invite
      begin
        Slack.configure do |config|
            config.token = ENV['SLACK_API_TOKEN']
            raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
        end
        client = Slack::Web::Client.new
        result = client.admin_users_invite(channel_ids: @data[:channels], team_id: @team_id, email: @data[:user].email, resend: false, is_restricted: false)
      rescue Exception => e
        puts e
      end
    end

    def users_list
      begin
        result = @client.users_list(limit: 200)
        result = result.members
        return result
      rescue Exception => e
        puts e
        result = "get user list error"
        return result
      end
    end

    def users_conversation_open
      begin
        result = @client.conversations_open(users: @data[:users])
        result = result.channel
        return result
      rescue Exception => e
        puts e
        result = "conversion open error"
        return result
      end
    end
end