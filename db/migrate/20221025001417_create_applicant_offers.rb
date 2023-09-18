class CreateApplicantOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :applicant_offers do |t|
      t.references :applicant, foreign_key: true, index: true
      t.references :job, foreign_key: true, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :title, null: false
      t.integer :base_salary, default: 0, null: false
      t.integer :share_stock, default: 0, null: false
      t.datetime :valid_until_date
      t.string :valid_start_date
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
