class Team < ApplicationRecord
    include Filterable

    belongs_to :user
    belongs_to :company
    has_many :team_members, dependent: :destroy
    has_many :jobs, dependent: :destroy
end
