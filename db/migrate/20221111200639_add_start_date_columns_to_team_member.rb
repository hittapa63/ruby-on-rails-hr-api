class AddStartDateColumnsToTeamMember < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:team_members, :start_date)
      add_column :team_members, :start_date, :datetime
    end
    unless ActiveRecord::Base.connection.column_exists?(:team_members, :review_schedule)
      add_column :team_members, :review_schedule, :integer
    end
    unless ActiveRecord::Base.connection.column_exists?(:team_members, :review_schedule)
      add_column :team_members, :review_schedule, :integer
    end
    unless ActiveRecord::Base.connection.column_exists?(:team_members, :photo_url)
      add_column :team_members, :photo_url, :string
    end
  end
end
