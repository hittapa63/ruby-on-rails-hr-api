class AddEmergencyColumnToUser < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:users, :emergency_first_name)
      add_column :users, :emergency_first_name, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:users, :emergency_last_name)
      add_column :users, :emergency_last_name, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:users, :emergency_email)
      add_column :users, :emergency_email, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:users, :emergency_phone_number)
      add_column :users, :emergency_phone_number, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:users, :emergency_relationship)
      add_column :users, :emergency_relationship, :string
    end
  end
end
