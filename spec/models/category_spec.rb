require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  # wildlife = Fabricate(:category, name: "Wildlife")
  # wildlife.downcase.should include("wildlife".downcase)
end