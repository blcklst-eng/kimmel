require "rails_helper"

RSpec.describe RecordingPolicy do
  describe "#view?" do
    it "returns true if the user is admin" do
      user = build_stubbed(:user, :admin)
      recording = build_stubbed(:recording)
      policy = described_class.new(user, recording)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns true if the call is recorded and the user owns the call" do
      user = create(:user)
      call = create(:incoming_call, recorded: true, user: user)
      recording = create(:recording, call: call)
      policy = described_class.new(user, recording)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns false if the call is not recorded" do
      user = create(:user)
      call = create(:incoming_call, recorded: false, user: user)
      recording = create(:recording, call: call)
      policy = described_class.new(user, recording)

      result = policy.view?

      expect(result).to be(false)
    end

    it "returns false if the user does not have permission" do
      user = build_stubbed(:user)
      call = build_stubbed(:call, recorded: true)
      recording = build_stubbed(:recording, call: call)
      policy = described_class.new(user, recording)

      result = policy.view?

      expect(result).to be(false)
    end
  end
end
