class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.references :note, foreign_key: true
      t.date :remind_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
