class AddFirstLoginColumnToUser < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:users, :is_first_login)
      add_column :users, :is_first_login, :boolean, default: true
    end      
    if ActiveRecord::Base.connection.column_exists?(:users, :team)
      remove_column :users, :team
    end
  end
end
