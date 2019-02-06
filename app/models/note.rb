require 'elasticsearch/model'
class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :comments
  searchkick
  #searchkick highlight: [:title,:description]
  Note.reindex
  def self.records
    return Note.where("is_active = true")
  end
end
Note.import
