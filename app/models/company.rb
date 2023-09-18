class Company < ApplicationRecord

    belongs_to :user

    has_many :user_permissions, dependent: :destroy
    has_many :teams, dependent: :destroy
    has_many :important_links, dependent: :destroy
    has_many :team_members, through: :teams, dependent: :destroy

    after_save :post_message_channel
    after_create :create_hr_channel

    private
    def post_message_channel
        blocks = [
            SLACK_HEADER_COMPANY_UPDATE,
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "A new company update has been posted. #{self.subject}. Click here to read update information <#{self.link}|here>"
                }
            }
        ]
        data = {
          channel_name: "##{GENERAL_CHANNEL}",
          blocks: blocks
        }
        SlackService::Channel.call(data: data, action_name: 'post_message')
        return true
    end

    def create_hr_channel
        data = {
            channel_name: HR_CHANNEL,
            is_private: false
        }
        result = SlackService::Channel.call(data: data, action_name: 'channel_create')
    end
end
