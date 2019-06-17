require 'rails_helper'

RSpec.describe Note, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:user) }
  it { should have_many(:shares) }
  it { should have_many(:comments) }
  it { should have_many(:shared_by_users) }
  it { should have_many(:reminders) }

  # describe ".shared_users" do
  #   let!(:owner) { FactoryBot.create(:user) }
  #   let!(:shared_user) { FactoryBot.create(:user) }
  #   let!(:permission) { FactoryBot.create(:permission, name: 'read') }
  #   let!(:note) { FactoryBot.create(:note, user_id: owner.id ) }
  #   let!(:share) { FactoryBot.create(:share, note_id: note.id, shared_by: owner.id, permission_id: permission.id, email: shared_user.email) }
  #   it "gets all users, who the notes are shared to" do
  #     expect(note.shared_users).to eq share
  #   end
  # end
end
