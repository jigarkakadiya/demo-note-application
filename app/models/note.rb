require 'elasticsearch/model'
class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  searchkick
  acts_as_taggable

  #
  ## Associations
  #
  belongs_to :user
  has_many(
    :shares,
    dependent: :destroy
  )
  has_many(
    :shared_by_users,
    through: :shares,
    source: :user
  )
  has_many(
    :comments,
    dependent: :destroy
  )
  acts_as_taggable_on :tags

  Note.reindex

  #
  ## Validations
  #
  validates :title, presence: true
  validates :description, presence: true

  #
  ## Custom Methods
  #
  def self.records
    return Note.where("is_active = true")
  end

  def shared_users
    Share.where(note_id: self.id)
  end
end
Note.import
