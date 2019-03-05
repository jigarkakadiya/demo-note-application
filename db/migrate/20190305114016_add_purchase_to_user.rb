class AddPurchaseToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :has_purchased, :boolean, default: false
    add_reference :users, :plan, index: true
  end

  def down
    remove_reference :users, :plans, index: true
  end
end
