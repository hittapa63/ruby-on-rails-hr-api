class AddStageColumnsToApplicants < ActiveRecord::Migration[7.0]
  def change
    add_column :applicants, :stage, :string, default: "NEW"
    add_column :applicants, :source_type, :string, null: false
  end
end
