class ChangeDataTypeStartDateEndDate < ActiveRecord::Migration[8.1]
  def change
    remove_column :activities, :start_date, :date
    remove_column :activities, :end_date, :date
    add_column :activities, :start_date, :datetime
    add_column :activities, :end_date, :datetime
  end
end
