require "rails_helper"

RSpec.describe TemplatePolicy do
  describe "#view?" do
    it "returns true if the template is global" do
      user = build_stubbed(:user)
      template = build_stubbed(:global_template)
      policy = described_class.new(user, template)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      template = build_stubbed(:template)
      policy = described_class.new(user, template)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns true for a user that owns the template" do
      user = build_stubbed(:user)
      template = build_stubbed(:template, user: user)
      policy = described_class.new(user, template)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      template = build_stubbed(:template)
      policy = described_class.new(user, template)

      result = policy.view?

      expect(result).to be(false)
    end
  end

  describe "#manage?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      template = build_stubbed(:template)
      policy = described_class.new(user, template)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns true for a user that owns the template" do
      user = build_stubbed(:user)
      template = build_stubbed(:template, user: user)
      policy = described_class.new(user, template)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      template = build_stubbed(:template)
      policy = described_class.new(user, template)

      result = policy.manage?

      expect(result).to be(false)
    end
  end
end
