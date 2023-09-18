class Title < ApplicationRecord

    belongs_to :user
    has_many :team_members, dependent: :destroy
end
