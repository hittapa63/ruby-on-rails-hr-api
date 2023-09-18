class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :photo_url
      t.string :password_digest
      t.string :user_type, default: "USER"
      t.string :team
      t.string :status, default: "ACTIVE"
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :phone_number
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
