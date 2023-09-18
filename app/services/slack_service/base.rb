require 'slack-ruby-client'

class SlackService::Base < ApplicationService
    def initialize()
        Slack.configure do |config|
            # config.token = ENV['SLACK_API_TOKEN']
            config.token = ENV['SLACK_WEBHOOK_URL']
            raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
        end
    end
  end