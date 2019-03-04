# frozen_string_literal: true

class RemoveFkeyNotes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :notes, :users
  end
end
