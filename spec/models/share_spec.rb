require 'rails_helper'

RSpec.describe Share, type: :model do
  it { should belong_to(:note) }
  it { should belong_to(:permission) }
  it { should belong_to(:user) }
end
