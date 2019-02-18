class Share < ApplicationRecord
  belongs_to :note, dependent: :destroy
  belongs_to :permission
  belongs_to :user, foreign_key: :shared_by, class_name: "User"  
end
