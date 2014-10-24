require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:name) }

  it "should check for case insensitivity" do
    wildlife = Fabricate(:category, name: "Wildlife", user_id: 1)
    wildlife2 = Category.new(name: "wIlDlIfE", user_id: 1)
    expect(wildlife2.valid?).to eq(false)
  end
  it "should allow different users to have the same category name" do
    wildlife1 = Fabricate(:category, name: "Wildlife", user_id: 1)
    wildlife2 = Category.new(name: "Wildlife", user_id: 2)
    expect(wildlife2.valid?).to eq(true)
  end
end