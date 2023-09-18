class CreateUserPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_permissions do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :role
      t.string :status, default: "ACTIVE"
      t.timestamp  :discarded_at

      t.timestamps
    end
  end
end
