class ChangeDataType < ActiveRecord::Migration[5.2]
  def change
    change_column :reminders, :remind_date, :datetime
  end
end
