class User < ApplicationRecord

    has_many :companies, dependent: :destroy
    has_many :user_permissions, dependent: :destroy
    has_many :important_links, through: :companies, dependent: :destroy
    has_many :teams, dependent: :destroy
    has_many :titles, dependent: :destroy
    has_many :jobs, through: :teams, dependent: :destroy
    has_many :team_members, through: :teams, dependent: :destroy
    has_many :applicants, through: :jobs, dependent: :destroy
    has_many :company_requests, dependent: :destroy

    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, presence: true, uniqueness: true
    validates :password,
                length: { minimum: 6 },
                if: -> { new_record? || !password.nil? }

    scope :manager, -> { where(user_type: 'USER') }

    def active_account
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!
        UserMailer.sign_up(self).deliver_now
    end

    def generate_password_token!
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!
        ForgotPasswordMailer.forgot_password(self).deliver_now
    end
        
    def password_token_valid?
        (self.reset_password_sent_at + 4.hours) > Time.now.utc
    end
        
    def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        save!
        self.post_message_channel
        UserMailer.reset_password(self).deliver_now

    end

    def my_all_companies
        items = []
        items += self.companies
        TeamMember.where(email_address: self.email).active.map do |team_member|
            items << team_member.company
        end
        return items
    end

    def my_all_teams
        items = []
        items += self.teams
        TeamMember.where(email_address: self.email).active.map do |team_member|
            items << team_member.team
        end
        return items
    end

    def my_all_team_members
        members = []            
        self.my_all_teams.each { |team| members += team.team_members }
        return members
    end

    def my_all_jobs
        items = []
        self.my_all_teams.each { |team| items += team.jobs }
        return items
    end

    def my_all_important_links
        items = []
        self.my_all_companies.each {|company| items += company.important_links}
        return items
    end

    def teams_as_member
        teams = TeamMember.where(email_address: self.email).active.map do |team_member|
            team_member.team
        end.flatten
        return teams
    end

    def jobs_as_member
        jobs = []
        TeamMember.where(email_address: self.email).active.map do |team_member|                
            jobs += team_member.team.jobs
        end.flatten
        return jobs
    end

    def members_as_member
        members = []
        TeamMember.where(email_address: self.email).active.map do |team_member|                
            members += team_member.team.team_members
        end.flatten
        return members
    end

    def companies_as_member
        companies = TeamMember.where(email_address: self.email).active.map do |team_member|
            team_member.company
        end.flatten
    end

    def isAdmin
        isAdmin = self.user_type == 'ADMIN'
    end

    def isManager
        isManager = self.user_type == 'USER'
    end

    def isMember
        isMember = self.user_type == 'MEMBER'
    end

    def name
        "#{self.first_name} #{self.last_name}"
    end

    def send_message_to_slack(blocks)
        if self.slack_channel_id.present?
            data = {
                blocks: blocks,
                channel_name: "#{self.slack_channel_id}"
            }
            SlackService::Channel.call(data: data, action_name: 'post_message')
        end
    end
    
    private
    
    def generate_token
        SecureRandom.hex(10)
    end

    def post_message_channel
        if self.slack_channel_id.present?
            blocks = [
                SLACK_HEADER_ENROLL,
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "Thanks for enrolling in Welcome HR! hr.welcomehomes.com"
                    }
                }
            ]
            data = {
                blocks: blocks,
                channel_name: "#{self.slack_channel_id}"
            }
            SlackService::Channel.call(data: data, action_name: 'post_message')
        end
    end
end
