class CreateApplicantNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :applicant_notes do |t|
      t.references :applicant, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.string :note_type, null: false
      t.text :description
      t.integer :responsiblity_score, default: 0, null: false
      t.integer :growing_score, default: 0, null: false
      t.integer :culture_score, default: 0, null: false
      t.boolean :hire_applicant, default: false
      t.integer :homework_score, default: 0, null: false
      t.integer :session_score, default: 0, null: false
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
