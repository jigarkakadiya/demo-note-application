class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :notes
  has_many :comments
  has_many :shares, class_name: "Share", foreign_key: "shared_by"
  has_many :shared_notes, :through => :shares, :source => :note
  has_one_attached :profile_photo

  def notes_shared_with_me
    Note.joins(:shares).where(shares: {email: self.email}).select("*")
  end

  def notes_shared_by_me
    Note.joins(:shares).where(shares: {shared_by: self.id})
  end
end
