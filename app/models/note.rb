require 'elasticsearch/model'
class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :comments

end
#Note.import(force: true)
