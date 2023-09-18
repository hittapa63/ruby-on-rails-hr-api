class CreateTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :titles do |t|
      t.references :user, foreign_key: true, index: true
      t.string :title, null: false
      t.string :description
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
