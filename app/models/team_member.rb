class TeamMember < ApplicationRecord
    include Filterable

    belongs_to :team
    belongs_to :title
    has_many :company_requests, dependent: :destroy
    has_many :team_member_notes, dependent: :destroy
    has_many :job_interviewers, dependent: :destroy

    has_one :company, :through => :team

    validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :check_already_added_as_team_member, on: :create

    after_save :create_user
    after_update :create_user

    scope :ordered, -> { order(created_at: :desc) }
    scope :active, -> { where(status: 'ACTIVE') }

    # filters
    scope :team_id, ->(value) { where(team_id: value) }
    scope :title_id, ->(value) { where(title_id: value) }
    scope :first_name, ->(value) { where(first_name: value) }
    scope :last_name, ->(value) { where(last_name: value)}
    scope :email_address, ->(value) { where(email_address: value)}
    scope :status, ->(value) { where(status: value)}
    scope :start_date, ->(value) { where('applicants.created_at >= ?', value) }
    scope :end_date, ->(value) { where('applicants.created_at <= ?', value) }

    def post_general_channel(current_user)
        blocks = [
            SLACK_HEADER_NEW_USER,
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "#{current_user.name} added #{self.first_name} #{self.last_name} user to #{self.team.name}"
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

    def user
        User.find_by_email(self.email_address).first
    end

    def period_days
        self.review_schedule * 30
    end

    def reviewIsIn2Weeks
        (period_days - (Time.now - self.start_date).to_i % period_days <= 14) && (period_days - (Time.now - self.start_date).to_i % period_days > 7)
    end

    def reviewIsInWeek
        period_days - (Time.now - self.start_date).to_i % period_days < 7
    end

    private

    def create_user
        if User.find_by_email(self.email_address).blank?
            user = User.new
            user.first_name = self.first_name
            user.last_name = self.last_name
            user.email = self.email_address
            user.username = ('0'..'z').to_a.shuffle.first(12).join
            user.password = 'aaaaaa'
            user.user_type = 'MEMBER'
            if user.save
                data = {
                    user: user,
                    channels: "##{GENERAL_CHANNEL}, ##{HR_CHANNEL}}"
                }
                SlackService::User.call(data: data, action_name: 'users_invite')
                user.active_account
            end
        end            
    end

    def check_already_added_as_team_member
        team_member = TeamMember.where(team_id: self.team_id, email_address: self.email_address).first
        if team_member.present?
            errors.add(:email, "Already used this email in the team.")
        end
    end
end
