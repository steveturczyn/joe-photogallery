require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it "should check for case insensitivity" do
    wildlife = Fabricate(:category, name: "Wildlife")
    expect(wildlife.name.downcase).to match("wIlDlIfE".downcase)
  end
  it "should allow different users to have the same category name" do
    wildlife1 = Fabricate(:category, name: "Wildlife", user_id: 1)
    wildlife2 = Fabricate(:category, name: "Wildlife", user_id: 2)
    expect(wildlife2).to be_present
  end
end