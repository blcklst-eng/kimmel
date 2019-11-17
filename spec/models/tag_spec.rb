require "rails_helper"

RSpec.describe Tag, type: :model do
  context "validation" do
    it "is valid with valid attributes" do
      expect(Tag.new(name: "New")).to be_valid
    end

    it { should validate_presence_of(:name) }
  end

  describe "#name=" do
    it "lowercases value" do
      tag = Tag.new
      tag.name = "Testing"

      expect(tag.name).not_to eq("Testing")
      expect(tag.name).to eq("testing")
    end
  end

  describe "#to_s" do
    it "converts tag to a string from name" do
      tag = Tag.new
      tag.name = "this"

      expect(tag.to_s).to eq("this")
    end
  end
end
