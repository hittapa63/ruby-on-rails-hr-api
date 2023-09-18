class Job < ApplicationRecord
    include Filterable

    belongs_to :team
    has_many :job_interviewers, dependent: :destroy
    has_many :applicants, dependent: :destroy

    validates :title, presence: true, uniqueness: true
    validates :title,
                length: { minimum: 6 },
                if: -> { new_record? || !title.nil? }

    validate :create_channel, on: :create

    # filters
    scope :status, ->(value) { where(status: value) }
    scope :role, ->(value) { where(role: value) }
    scope :active, -> { where(status: "ACTIVE") }

    def create_channel
        channel_name = self.title.gsub(' ', '-').downcase
        data = {
            channel_name: channel_name,
            is_private: true
        }
        result = SlackService::Channel.call(data: data, action_name: 'channel_create')
        if result.kind_of?(String) == false && result.id.present?
            self.slack_channel_id = result.id
            data = {
                channel_name: result.id,
                user: self.team.user
            }
            SlackService::Channel.call(data: data, action_name: 'channel_add_user')
        else
            errors.add(:title, "Slack service #{result}")
        end
    end
end
