require "rails_helper"

RSpec.describe VoicemailPolicy do
  describe "#view?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      voicemail = build_stubbed(:voicemail)
      policy = described_class.new(user, voicemail)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns true for a user that owns the voicemail" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, voicemailable: call)
      policy = described_class.new(user, voicemail)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      voicemail = build_stubbed(:voicemail)
      policy = described_class.new(user, voicemail)

      result = policy.view?

      expect(result).to be(false)
    end
  end
end
