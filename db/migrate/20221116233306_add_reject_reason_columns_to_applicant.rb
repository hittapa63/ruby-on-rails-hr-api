class AddRejectReasonColumnsToApplicant < ActiveRecord::Migration[7.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:applicants, :rejected_reason)
      add_column :applicants, :rejected_reason, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:applicants, :rejected_text)
      add_column :applicants, :rejected_text, :text
    end
  end
end
