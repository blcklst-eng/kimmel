require "rails_helper"

RSpec.describe Participant, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:participant)).to be_valid
    end

    it { should validate_presence_of(:status) }

    it "is not valid with a invalid contact" do
      invalid_contact = build(:contact, phone_number: nil)
      expect(build(:participant, contact: invalid_contact)).not_to be_valid
    end
  end

  context "callbacks" do
    describe "after_commit" do
      it "touches the contact if the call is incoming" do
        freeze_time do
          contact = create(:contact, last_contact_at: 1.week.ago)
          call = create(:incoming_call)
          create(:participant, call: call, contact: contact)

          expect(contact.last_contact_at).to eq(Time.current)
        end
      end

      it "does not touche the contact if the call is outgoing" do
        freeze_time do
          contact = create(:contact, last_contact_at: 1.week.ago)
          call = create(:outgoing_call)
          create(:participant, call: call, contact: contact)

          expect(contact.last_contact_at).to eq(1.week.ago)
        end
      end

      it "broadcasts if the status changes" do
        participant = create(:participant)

        expect {
          participant.update(status: :completed)
        }.to have_enqueued_job(BroadcastParticipantStatusChangedJob)
      end

      it "does not broadcast if they status does not change" do
        participant = create(:participant)

        expect {
          participant.update(sid: "12345")
        }.not_to have_enqueued_job(BroadcastParticipantStatusChangedJob)
      end
    end
  end

  describe ".active" do
    it "returns all initiated participants" do
      active_participant = create(:participant, :initiated)
      inactive_participant = create(:participant, :completed)

      result = described_class.active

      expect(result).to include(active_participant)
      expect(result).not_to include(inactive_participant)
    end

    it "returns all in_progress participants" do
      active_participant = create(:participant, :in_progress)
      inactive_participant = create(:participant, :completed)

      result = described_class.active

      expect(result).to include(active_participant)
      expect(result).not_to include(inactive_participant)
    end
  end
end
