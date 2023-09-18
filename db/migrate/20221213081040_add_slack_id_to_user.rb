class AddSlackIdToUser < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:users, :slack_id)
      add_column :users, :slack_id, :string
    end
  end
end
