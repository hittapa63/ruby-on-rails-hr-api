class ImportantLinkSerializer < ActiveModel::Serializer
  belongs_to :company
  attributes :id, :company_id, :name, :description, :url, :status, :created_at, :updated_at
end
