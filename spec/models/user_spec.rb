require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:notes) }
  it { should have_many(:shares) }
  it { should have_many(:comments) }
  it { should have_many(:shared_notes) }
  it { should have_many(:reminders) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:contact) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:password_confirmation) }
  it { should validate_length_of(:name) }
  it { should validate_length_of(:contact) }
  it { should validate_length_of(:password) }
  it { should validate_numericality_of(:contact) }
  it { should validate_confirmation_of(:password) }

  describe ".notes_shared_with_me" do
    let!(:owner) { FactoryBot.create(:user) }
    let!(:permission) { FactoryBot.create(:permission, name: 'read') }
    let!(:note) { FactoryBot.create(:note, user_id: owner.id ) }
    let!(:shared_user) { FactoryBot.create(:user) }
    let!(:share) { FactoryBot.create(:share, note_id: note.id, shared_by: owner.id, permission_id: permission.id, email: shared_user.email) }
    it "gets all notes shared with current user" do
      expect(shared_user.notes_shared_with_me.count).to eq 1
    end
  end

  describe ".my_notes" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:note1) { FactoryBot.create(:note, user_id: user.id) }
    let!(:note2) { FactoryBot.create(:note, user_id: user.id, is_active: false) }
    it "gets all active notes of current user" do
      expect(user.my_notes.count).to eq 1
    end
  end

  # describe ".avatar" do
  #   let!(:user) { FactoryBot.create(:user) }
  #   it "checks if user has avatar attached" do
  #     user.profile_photo = Faker::Avatar.image
  #     expect(user.avatar).not_to eq '/img_avatar1.png'
  #   end
  # end
end
