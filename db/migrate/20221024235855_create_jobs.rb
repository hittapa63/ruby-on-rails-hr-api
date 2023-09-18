class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.references :team
      t.string :title, null: false
      t.string :role, null: false
      t.text :responsibilities, null: false
      t.text :requirements
      t.integer :compensation, default: 0, null: false
      t.text :homework_prompt
      t.string :homework_pdf
      t.string :applicant_requirements, null: false
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
