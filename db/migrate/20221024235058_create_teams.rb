class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true, index: true
      t.string :description
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
