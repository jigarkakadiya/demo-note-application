class RemoveUseridAddUseremail < ActiveRecord::Migration[5.2]
  def change
    remove_column :shares, :user_id
    add_column :shares, :email, :string
  end
end
