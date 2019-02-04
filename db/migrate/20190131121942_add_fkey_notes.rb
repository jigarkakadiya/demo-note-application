class AddFkeyNotes < ActiveRecord::Migration[5.2]
  def change
    add_reference :notes, :user, index: true
  end
end
