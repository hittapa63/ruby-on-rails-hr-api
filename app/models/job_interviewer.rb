class JobInterviewer < ApplicationRecord
    include Filterable

    belongs_to :job
    belongs_to :team_member

    after_create :add_user_channel

    private

    def add_user_channel
        data = {
            channel_name: self.slack_channel_id,
            user: self.team_member.user
        }
        result = SlackService::Channel.call(data: data, action_name: 'channel_add_user')
    end
end
