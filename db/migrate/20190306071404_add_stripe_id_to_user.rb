class AddStripeIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sripe_id, :string
  end
end
