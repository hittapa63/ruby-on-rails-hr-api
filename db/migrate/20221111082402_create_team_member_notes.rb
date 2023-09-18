class CreateTeamMemberNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :team_member_notes do |t|
      t.references :team_member, foreign_key: true, index: true
      t.string :note_type, null: false
      t.text :description
      t.string :scoring_matrix, null: true
      t.string :praise, null: true
      t.string :improvements, null: true
      t.string :plan_name, null: true
      t.text :core_kpis, null: true
      t.datetime :start_date, null: true
      t.datetime :end_date, null: true
      t.string :reason_for_change, null: true
      t.integer :base_comp, null: true
      t.integer :stop_comp, null: true
      t.datetime :effective_date, null: true
      t.integer :manager_id, null: true
      t.integer :team_id, null: true
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
