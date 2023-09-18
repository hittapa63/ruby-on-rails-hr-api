class CompanyRequest < ApplicationRecord
    include Filterable


    belongs_to :user
    belongs_to :team_member

    validate :check_request_params

    after_save :post_general_channel

    scope :ordered, -> { order(created_at: :desc) }

    # filters
    scope :user_id, ->(value) { where(user_id: value) }
    scope :team_member_id, ->(value) { where(team_member_id: value) }
    scope :request_type, ->(value) { where(request_type: value) }
    scope :category, ->(value) { where(category: value)}
    scope :status, ->(value) { where(status: value)}
    scope :from_date, ->(value) { where('company_requests.from_date >= ?', value) }
    scope :to_date, ->(value) { where('company_requests.to_date <= ?', value) }

    private

    def check_request_params
        if self.request_type == 'TIME OFF OR REMOTE WORK'
            diff = (self.to_date.to_date - self.from_date.to_date).to_i
            if diff < 0
                errors.add(:date, "Invalid from and to dates")
            end                
        end
    end

    def post_general_channel
        if self.request_type == 'HR MEETING'
            blocks = [
                SLACK_HEADER_HR_MEETING,
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "#{self.user.name} has requested an HR meeting. Details of the request can be found <#{FRONTEND_HR_MEETINGS_SHOW}/#{self.id}|here>"
                    }
                }
            ]
            data = {
                channel_name: "##{HR_CHANNEL}",
                blocks: blocks
            }   
            SlackService::Channel.call(data: data, action_name: 'post_message')     
        end
        if self.request_type == 'ANONYMOUS HR NOTE'
            blocks = [
                SLACK_HEADER_HR_NOTE,
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "A new anonymous note has been submitted to HR\nThe note is as follows\n #{self.note}"
                    }
                }
            ]
            data = {
                channel_name: "##{HR_CHANNEL}",
                blocks: blocks
            }
            SlackService::Channel.call(data: data, action_name: 'post_message')
        end
        if self.request_type == 'TIME OFF OR REMOTE WORK'
            blocks = [
                SLACK_HEADER_TODAY_TIME_OFF_REQUEST,
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "#{self.user.name} has requested time off from #{self.from_date.to_date} ~ #{self.to_date.to_date} approval request has been sent to #{self.team_member.team.user.name}"
                    }
                }
            ]
            data = {
                channel_name: "##{HR_CHANNEL}",
                blocks: blocks
            }
            SlackService::Channel.call(data: data, action_name: 'post_message')
            if self.team_member.team.user.slack_channel_id.present?
                blocks = [
                    SLACK_HEADER_TODAY_TIME_OFF_REQUEST,
                    {
                        "type": "section",
                        "text": {
                            "type": "mrkdwn",
                            "text": "#{self.user.name} has requested time off from #{self.from_date.to_date} ~ #{self.to_date.to_date}"
                        }
                    }
                ]
                data = {
                    channel_name: "#{self.team_member.team.user.slack_channel_id}",
                    blocks: blocks
                }
                SlackService::Channel.call(data: data, action_name: 'post_message')
            end
        end
    end
end
