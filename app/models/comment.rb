# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :note
  belongs_to :user
  delegate :name , to: :user, prefix: true

  #
  ## Validations
  #
  validates :description, presence: true
end
