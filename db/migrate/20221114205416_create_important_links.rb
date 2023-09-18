class CreateImportantLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :important_links do |t|
      t.references :company, foreign_key: true, index: true
      t.string :name, null: false
      t.text :description
      t.string :url
      t.string :status, default: "ACTIVE"

      t.timestamp  :discarded_at

      t.timestamps
    end

    change_table :companies do |t|
      t.change :text, :text
    end
  end
end
