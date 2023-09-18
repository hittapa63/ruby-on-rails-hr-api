class SlackChannelIdToUser < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:users, :slack_channel_id)
      add_column :users, :slack_channel_id, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:jobs, :slack_channel_id)
      add_column :jobs, :slack_channel_id, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:companies, :slack_team_id)
      add_column :companies, :slack_team_id, :string
      add_column :companies, :slack_api_token, :string
      add_column :companies, :slack_webhook_url, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:applicants, :slack_channel_id)
      add_column :applicants, :slack_channel_id, :string
    end
  end
end
