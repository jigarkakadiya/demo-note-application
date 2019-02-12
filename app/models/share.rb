class Share < ApplicationRecord
  belongs_to :note
  belongs_to :permission
  has_one :user, foreign_key: :shared_by
end
