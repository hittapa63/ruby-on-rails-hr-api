# schema
# stage: [NEW, REVIEWED, INDEED, INTERVIEWING, OFFER, REJECTED]

class Applicant < ApplicationRecord
    include Filterable

    belongs_to :job
    has_many :applicant_offers, dependent: :destroy
    has_many :applicant_notes, dependent: :destroy

    after_update :update_stage_with_email

    scope :ordered, -> { order(created_at: :desc) }

    # filters
    scope :stage, ->(value) { where(stage: value) }
    scope :source_type, ->(value) { where(source_type: value) }
    scope :start_date, ->(value) { where('applicants.created_at >= ?', value) }
    scope :end_date, ->(value) { where('applicants.created_at <= ?', value) }
    scope :today, -> { where("applicants.created_at >= ?", Time.zone.now.beginning_of_day) }

    private

    def update_stage_with_email
        if self.stage == 'REJECTED'
            ApplicantMailer.applicant_reject(self).deliver_now
            @text = "<#{FRONTEND_APPLICANTS_SHOW}/#{self.id} |#{self.first_name} #{self.last_name}> - Rejected"
        else
            @text = "<#{FRONTEND_APPLICANTS_SHOW}/#{self.id} |#{self.first_name} #{self.last_name}> - Moved to #{self.stage.downcase} stage"
        end
        if self.job.slack_channel_id.present?
            post_message_channel
        end
    end

    def post_message_channel
        blocks = [
            SLACK_HEADER_TODAY_APPLICANT_STATUS_CHANGES,
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "#{@text}"
                }
            }
        ]
        data = {
          channel_name: self.job.slack_channel_id,
          blocks: blocks
        }
        SlackService::Channel.call(data: data, action_name: 'post_message')
    end

end
