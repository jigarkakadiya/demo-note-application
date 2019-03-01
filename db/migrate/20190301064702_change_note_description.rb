# frozen_string_literal: true

class ChangeNoteDescription < ActiveRecord::Migration[5.2]
  def change
    change_column :notes, :description, :text, null: true
  end
end
