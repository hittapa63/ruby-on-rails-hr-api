class ApplicantSerializer < ActiveModel::Serializer
  # has_many :applicant_offers, dependent: :destroy
  # has_many :applicant_notes, dependent: :destroy
  attributes :id, :job_id, :source_url, :portfolio, :resume, :cover, :first_name, :middle_name, :last_name, :status, :created_at, :updated_at, :discarded_at, :stage, :source_type
end
