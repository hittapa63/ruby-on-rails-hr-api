class AddJobTitleColumnsToMember < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:team_members, :job_title_id)
      add_column :team_members, :job_title_id, :integer
    end
  end
end
