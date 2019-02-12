class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable
  has_many :notes
  has_many :comments
  has_many :shares, :through => :notes
  has_one_attached :profile_photo
end
