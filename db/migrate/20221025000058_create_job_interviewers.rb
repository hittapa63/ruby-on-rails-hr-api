class CreateJobInterviewers < ActiveRecord::Migration[7.0]
  def change
    create_table :job_interviewers do |t|
      t.references :job, foreign_key: true, index: true
      t.references :team_member, foreign_key: true, index: true
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
