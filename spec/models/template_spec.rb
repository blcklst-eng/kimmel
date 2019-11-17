require "rails_helper"

RSpec.describe Template, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:template)).to be_valid
    end

    it { should validate_presence_of(:body) }

    it "is not valid without at least one tag" do
      template = build(:template, tags: [])

      expect(template).not_to be_valid
    end
  end

  context "#add_tag" do
    it "adds a tag" do
      template = create(:template, tags: ["testing"])

      expect(template.tags.count).to eq(1)
    end
  end

  describe "#tags=" do
    it "removes all tags and adds new tags" do
      template = create(:template)
      template.tags = ["new"]

      expect(template.tags).not_to include("new")
      expect(template.tags.count).to eq(1)
    end
  end

  describe ".for_user" do
    it "returns user templates" do
      user = create(:user)
      template = create(:template, user: user)

      templates = Template.for_user(user).all

      expect(templates).to include(template)
    end
  end

  describe ".global" do
    it "returns global templates" do
      template = create(:global_template)

      templates = Template.global.all

      expect(templates).to include(template)
    end
  end

  describe "#global?" do
    it "returns true for a global template" do
      template = create(:global_template)

      expect(template.global?).to eq true
    end

    it "returns false for a regular template" do
      template = create(:template)

      expect(template.global?).to eq false
    end
  end

  describe ".search_by_tag" do
    it "returns template found by tag search" do
      template = create(:template, tags: ["testing"])

      expect(Template.search_by_tag("test")).to include(template)
    end
  end
end
