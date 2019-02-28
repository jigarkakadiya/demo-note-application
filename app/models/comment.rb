# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :note
  belongs_to :user
end
