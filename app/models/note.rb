require 'elasticsearch/model'
class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :comments
  searchkick
  acts_as_taggable
  acts_as_taggable_on :tags
  #searchkick highlight: [:title,:description]
  Note.reindex
  def self.records
    return Note.where("is_active = true")
  end
end
Note.import
