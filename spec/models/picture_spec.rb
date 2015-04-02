require 'spec_helper'

describe Picture do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category_id) }

  it "requires first picture of user to represent user" do
    alice = Fabricate(:user)
    apples = Fabricate(:category, user: alice)
    mcintosh = Fabricate.build(:picture, category: apples)
    expect(mcintosh.valid?).to eq(false)
    expect(mcintosh.errors.full_messages).to include('Represents user Your first picture must represent the user.')
  end

  it "recognizes that second picture in category does not need to represent user" do
    alice = Fabricate(:user)
    apples = Fabricate(:category, user: alice)
    delicious = Fabricate(:picture, category: apples, represents_user: apples.user, represents_category: apples)
    mcintosh = Fabricate.build(:picture, category: apples)
    expect(mcintosh.valid?).to eq(true)
  end

  it "requires first picture of category to represent category" do
    alice = Fabricate(:user)
    apples = Fabricate(:category, user: alice)
    mcintosh = Fabricate(:picture, category: apples, represents_user: apples.user, represents_category: apples)
    bananas = Fabricate(:category, user: alice)
    chiquita = Fabricate.build(:picture, category: bananas)
    expect(chiquita.valid?).to eq(false)
    expect(chiquita.errors.full_messages).to include('Represents category This picture must represent the category.')
  end
end