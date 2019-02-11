class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.references :note
      t.references :user
      t.references :permission

      t.timestamps
    end
  end
end
