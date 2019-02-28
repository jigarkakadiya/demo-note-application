# frozen_string_literal: true

class AddSavedByToShare < ActiveRecord::Migration[5.2]
  def change
    add_column :shares, :shared_by, :integer
  end
end
