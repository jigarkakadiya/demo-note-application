# frozen_string_literal: true

class Permission < ApplicationRecord
  validates :name, presence: true
end
