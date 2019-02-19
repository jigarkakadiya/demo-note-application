class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :notes
  has_many :comments
  has_many :shares
  has_many :shares, foreign_key: :email
  has_many :shared_notes, :through => :shares, :source => :note
  has_one_attached :profile_photo

  def notes_shared_with_me
    Note.joins(:shares).where(shares: {email: self.email}).select("*")
  end

  def notes_shared_by_me
    Note.joins(:shares).where(shares: {shared_by: self.id})
  end

  def my_notes
    self.notes.where("is_active = true")
  end

  def self.from_omniauth(auth) #def self.create_from_provider_data(provider_data)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      #user.name = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.create_from_google_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do | user |
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = provider_data.info.name
      user.skip_confirmation!
    end
  end
end
