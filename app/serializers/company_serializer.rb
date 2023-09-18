class CompanySerializer < ActiveModel::Serializer
  belongs_to :user
  attributes :id, :user_id, :name, :subject, :text, :link, :created_at, :updated_at
end
