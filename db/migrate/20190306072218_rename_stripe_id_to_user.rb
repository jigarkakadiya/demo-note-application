class RenameStripeIdToUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :sripe_id, :stripe_id
  end
end
