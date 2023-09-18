class TeamSerializer < ActiveModel::Serializer
  belongs_to :user
  attributes :id, :name, :user_id, :description, :status, :discarded_at, :created_at, :updated_at
end
