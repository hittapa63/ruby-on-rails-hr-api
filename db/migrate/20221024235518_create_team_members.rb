class CreateTeamMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :team_members do |t|
      t.references :team, foreign_key: true, index: true
      t.references :title, foreign_key: true, index: true
      t.string :first_name
      t.string :last_name
      t.string :email_address, null: false
      t.integer :base_comp, default: 0, null: false
      t.integer :share_stock, default: 0, null: false
      t.boolean :onboarding_email, default: false
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
