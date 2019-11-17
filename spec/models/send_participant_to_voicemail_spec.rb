require "rails_helper"

RSpec.describe SendParticipantToVoicemail do
  describe "#call" do
    it "creates a new call with the existing participant" do
      user = create(:user)
      participant = build_stubbed(:participant)
      stub_const("ConnectCallToVoicemail", spy(call: Result.success))

      result = described_class.new(
        participant: participant,
        user: user
      ).call

      expect(result.success?).to be(true)
      new_call = Call.find_by(user: user)
      expect(new_call.in_state?(:no_answer)).to be(true)
      expect(new_call.participants.first.sid).to eq(participant.sid)
    end

    it "creates a new call with an existing contact" do
      user = create(:user)
      existing_contact = create(:contact, user: user)
      incoming_contact = create(:contact, phone_number: existing_contact.phone_number)
      participant = build_stubbed(:participant, contact: incoming_contact)
      stub_const("ConnectCallToVoicemail", spy(call: Result.success))

      result = described_class.new(
        participant: participant,
        user: user
      ).call

      expect(result.success?).to be(true)
      new_call = Call.find_by(user: user)
      new_participant = new_call.participants.first
      expect(new_participant.contact).to eq(existing_contact)
      expect(Contact.for_user(user).count).to eq(1)
    end

    it "still creates a no_answer call even if voicemail cannot be connected" do
      user = create(:user)
      existing_contact = create(:contact, user: user)
      incoming_contact = create(:contact, phone_number: existing_contact.phone_number)
      participant = build_stubbed(:participant, contact: incoming_contact)
      stub_const("ConnectCallToVoicemail", spy(call: Result.failure("No voicemail")))

      result = described_class.new(
        participant: participant,
        user: user
      ).call

      expect(result.success?).to be(false)
      new_call = Call.find_by(user: user)
      expect(new_call.in_state?(:no_answer)).to be(true)
    end
  end
end
