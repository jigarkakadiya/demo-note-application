# frozen_string_literal: true

require 'google/apis/calendar_v3'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :confirmable,
    :omniauthable,
    omniauth_providers: [:google_oauth2]
  )

  #
  ## Associations
  #
  has_many(
    :notes,
    dependent: :destroy
  )
  has_many(
    :comments,
    dependent: :destroy
  )
  has_many(
    :shares,
    dependent: :destroy,
    foreign_key: :email
  )
  has_many(
    :shared_notes,
    through: :shares,
    source: :note,
    dependent: :destroy
  ) # will get all the shared note by the user
  has_one_attached :profile_photo

  #
  ## Custom methods
  #
  def notes_shared_with_me
    Share.joins(:note).where('email = ? and is_active = true', email)
    # Note.joins(:shares).where(shares: {email: self.email}).select("*")
  end

  def notes_shared_by_me
    Note.joins(:shares).where('is_active = true and shared_by = ? ', id)
  end

  def my_notes
    notes.where(is_active: true)
  end
=begin
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
=end
  def self.create_from_google_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = provider_data.info.name
      user.skip_confirmation!
    end
  end
end
