require 'elasticsearch/model'
class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  searchkick
  acts_as_taggable

  belongs_to :user
  has_many :shares
  has_many :shared_by_users, through: :shares, source: :user
  has_many :comments
  acts_as_taggable_on :tags

  Note.reindex
  def self.records
    return Note.where("is_active = true")
  end
end
Note.import
