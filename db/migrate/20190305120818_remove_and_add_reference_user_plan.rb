class RemoveAndAddReferenceUserPlan < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :users, :plans
    add_reference :users, :plan, index: true
  end
end
