require "rails_helper"

RSpec.describe CallStatus do
  describe ".from_twilio" do
    it "builds the status class from a twilio status string" do
      result = described_class.from_twilio("queued")

      expect(result).to be_a(described_class)
    end
  end

  describe "#apply" do
    it "updates a call status" do
      call = create(:incoming_call)
      status = described_class.new(:initiated)

      result = status.apply(call)

      expect(result).to be(true)
      expect(call.in_state?(:initiated)).to be(true)
    end
  end

  describe "#no_answer?" do
    it "returns true if status represents no answer" do
      result = described_class.new(:busy).no_answer?

      expect(result).to be(true)
    end

    it "returns false if the status does not represent no answer" do
      result = described_class.new(:in_progress).no_answer?

      expect(result).to be(false)
    end
  end

  describe "#answered?" do
    it "returns true if status represents no answer" do
      result = described_class.new(:in_progress).answered?

      expect(result).to be(true)
    end

    it "returns false if the status does not represent no answer" do
      result = described_class.new(:busy).answered?

      expect(result).to be(false)
    end
  end
end
