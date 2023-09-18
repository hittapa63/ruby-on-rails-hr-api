class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.references :user, foreign_key: true, index: true
      t.string :name, null: false
      t.string :subject
      t.string :text
      t.string :link
      t.string :status, default: "ACTIVE"

      t.timestamp  :discarded_at

      t.timestamps
    end
    unless ActiveRecord::Base.connection.column_exists?(:teams, :company_id)
      add_reference :teams, :company, index: true
    end
  end
end
