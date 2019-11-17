require "rails_helper"

RSpec.describe BuildConferenceEvent do
  describe ".from" do
    it "translates a participant-join conference event into a class" do
      result = described_class.from(event: "participant-join", sid: "1234", conference_sid: "12345")

      expect(result).to be_a(ConferenceEvents::ParticipantJoin)
    end

    it "translates a participant-left conference event into a class" do
      result = described_class.from(event: "participant-leave", sid: "1234")

      expect(result).to be_a(ConferenceEvents::ParticipantLeave)
    end

    it "translates a conference-start conference event into a class" do
      result = described_class.from(event: "conference-start")

      expect(result).to be_a(ConferenceEvents::ConferenceStart)
    end

    it "translates a conference-end conference event into a class" do
      result = described_class.from(event: "conference-end")

      expect(result).to be_a(ConferenceEvents::ConferenceEnd)
    end

    it "does not return a status that we do not recognize" do
      result = described_class.from(event: "not-valid")

      expect(result).to be_a(ConferenceEvents::UnknownEvent)
    end
  end
end
