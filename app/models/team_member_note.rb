class TeamMemberNote < ApplicationRecord
    include Filterable

    belongs_to :team_member

    scope :ordered, -> { order(created_at: :desc) }
    scope :active, -> { where(status: 'ACTIVE') }

    # filters
    scope :team_member_id, ->(value) { where(team_member_id: value) }
    scope :note_type, ->(value) { where(note_type: value) }
    scope :description, ->(value) { where(first_name: value) }
    scope :scoring_matrix, ->(value) { where(scoring_matrix: value)}
    scope :praise, ->(value) { where(praise: value)}
    scope :improvements, ->(value) { where(improvements: value)}
    scope :plan_name, ->(value) { where(plan_name: value) }
    scope :core_kpis, ->(value) { where(core_kpis: value) }
    scope :start_date, ->(value) { where(start_date: value) }
    scope :end_date, ->(value) { where(end_date: value)}
    scope :reason_for_change, ->(value) { where(reason_for_change: value)}
    scope :base_comp, ->(value) { where(base_comp: value)}
    scope :stop_comp, ->(value) { where(stop_comp: value) }
    scope :effective_date, ->(value) { where(effective_date: value) }
    scope :manager_id, ->(value) { where(manager_id: value) }
    scope :team_id, ->(value) { where(team_id: value)}
    scope :status, ->(value) { where(status: value)}    
end
