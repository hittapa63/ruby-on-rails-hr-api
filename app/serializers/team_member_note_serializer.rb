class TeamMemberNoteSerializer < ActiveModel::Serializer
  attributes :id, :team_member_id, :note_type, :description, :scoring_matrix, :praise, :improvements, :plan_name, :core_kpis, :start_date, :end_date, :reason_for_change, :base_comp, :stop_comp, :effective_date, :manager_id, :team_id, :title_id, :status, :created_at, :updated_at
end
