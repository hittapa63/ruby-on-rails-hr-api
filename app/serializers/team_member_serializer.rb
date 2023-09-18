class TeamMemberSerializer < ActiveModel::Serializer
  belongs_to :team
  belongs_to :title
  has_one :company
  has_many :team_member_notes
  has_many :job_interviewers
  attributes :id, :team_id, :title_id, :job_title_id, :first_name, :last_name, :email_address, :base_comp, :share_stock, :onboarding_email, :status, :review_schedule, :start_date, :created_at, :updated_at
end
