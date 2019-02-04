class UserFields < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :contact, :string
    add_column :users, :do_autosave, :boolean
  end
end
