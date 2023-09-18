class AddTitleColumnToApplicantNote < ActiveRecord::Migration[7.0]
  def change
    add_column :applicant_notes, :title, :string
  end
end
