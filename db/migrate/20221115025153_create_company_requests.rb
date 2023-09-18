class CreateCompanyRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :company_requests do |t|
      t.references :user, foreign_key: true, index: true
      t.references :team_member, foreign_key: true, index: true
      t.string :request_type
      t.string :category
      t.text :note, null: true
      t.datetime :from_date, null: true
      t.datetime :to_date, null: true
      t.string :status, default: "PENDING"

      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
