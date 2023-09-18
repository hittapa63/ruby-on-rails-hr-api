class UserSerializer < ActiveModel::Serializer
  has_many :user_permissions
  attributes :id, :username, :email, :photo_url, :status, :first_name, :last_name, :phone_number, :middle_name, :address, :city, :state, :country, :postal_code, :is_first_login, :user_type, :discarded_at, :created_at, :updated_at
end
