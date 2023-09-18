class CompanyRequestSerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :team_member
  attributes :id, :user_id, :team_member_id, :request_type, :category, :from_date, :to_date, :note, :status, :created_at, :updated_at
end
