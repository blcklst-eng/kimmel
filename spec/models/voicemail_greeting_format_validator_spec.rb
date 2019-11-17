require "rails_helper"

describe VoicemailGreetingFormatValidator do
  describe "#validate" do
    it "allows acceptable content types" do
      record = double(
        voicemail_greeting: double(
          attached?: true,
          content_type: "audio/wav"
        ),
        errors: {voicemail_greeting: []}
      )

      described_class.new.validate(record)

      expect(record.errors[:voicemail_greeting].count).to be(0)
    end

    it "adds a error for a invalid mime type" do
      record = double(
        voicemail_greeting: double(
          attached?: true,
          content_type: "image/jpeg",
          purge: spy
        ),
        errors: {voicemail_greeting: []}
      )

      described_class.new.validate(record)

      expect(record.errors[:voicemail_greeting].count).to be(1)
    end
  end
end
