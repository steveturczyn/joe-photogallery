require 'spec_helper'

describe Image do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category_id) }
  it { should validate_presence_of(:image_link) }
  it { should validate_presence_of(:home) }
end