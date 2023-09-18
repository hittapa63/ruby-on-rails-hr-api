class ApplicantNote < ApplicationRecord
    include Filterable

    belongs_to :applicant

    scope :ordered, -> { order(created_at: :desc) }

    # filters
    scope :applicant_id, ->(value) { where(applicant_id: value) }
    scope :user_id, ->(value) { where(user_id: value) }
    scope :status, ->(value) { where(status: value) }
    scope :note_type, ->(value) { where(note_type: value)}
    scope :start_date, ->(value) { where('applicants.created_at >= ?', value) }
    scope :end_date, ->(value) { where('applicants.created_at <= ?', value) }
end
