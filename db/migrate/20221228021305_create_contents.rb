class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :type
      t.references :company, foreign_key: true
      t.string :status, default: "ACTIVE"
      t.text :content
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
