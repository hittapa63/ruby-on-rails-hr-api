class AddTeamIdColumnsToTeamMemberNote < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:team_member_notes, :title_id)
      add_column :team_member_notes, :title_id, :integer
    end
  end
end
