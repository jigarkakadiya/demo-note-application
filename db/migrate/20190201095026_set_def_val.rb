# frozen_string_literal: true

class SetDefVal < ActiveRecord::Migration[5.2]
  def change
    change_column :notes, :is_active, :boolean, default: true
    change_column :notes, :is_important, :boolean, default: false
  end
end
