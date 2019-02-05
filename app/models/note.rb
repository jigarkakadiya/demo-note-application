require 'elasticsearch/model'
class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :comments

  def records
    return Notes.where("is_active = true")
  end
end
#Note.import(force: true)
