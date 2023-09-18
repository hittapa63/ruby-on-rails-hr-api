class JobSerializer < ActiveModel::Serializer
  belongs_to :team
  has_many :applicants
  attributes :id, :team_id, :title, :role, :responsibilities, :requirements, :compensation, :homework_prompt, :homework_pdf, :applicant_requirements, :status, :discarded_at, :created_at, :updated_at
end
