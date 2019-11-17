require "rails_helper"

RSpec.describe MessageStatus do
  describe "#delivered?" do
    it "is true if the message status is delivered" do
      subject = described_class.new("delivered")

      result = subject.delivered?

      expect(result).to be(true)
    end

    it "is false if the message status is not delivered" do
      subject = described_class.new("not-delivered")

      result = subject.delivered?

      expect(result).to be(false)
    end
  end

  describe "#failed?" do
    it "is true if the message status is failed" do
      subject = described_class.new("failed")

      result = subject.failed?

      expect(result).to be(true)
    end

    it "is true if the message status is undelivered" do
      subject = described_class.new("undelivered")

      result = subject.failed?

      expect(result).to be(true)
    end

    it "is false if the message status is not failed or undelivered" do
      subject = described_class.new("not-failed")

      result = subject.failed?

      expect(result).to be(false)
    end
  end
end
