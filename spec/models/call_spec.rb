require "rails_helper"

RSpec.describe Call, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build_stubbed(:incoming_call)).to be_valid
      expect(build_stubbed(:outgoing_call)).to be_valid
    end

    it { should validate_numericality_of(:duration).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:duration) }
  end

  context "after_transition" do
    it "marks a call as viewed when transitioned to :in_progress" do
      call = create(:incoming_call, :initiated, :not_viewed)

      call.transition_to(:in_progress)

      expect(call.viewed?).to be(true)
    end

    it "broadcasts counts when a call was missed" do
      call = create(:incoming_call, :initiated, :not_viewed)

      expect {
        call.transition_to(:no_answer)
      }.to have_enqueued_job(BroadcastCountsJob)
    end

    include ActiveSupport::Testing::TimeHelpers
    it "sets the duration when a call is completed" do
      call = create(:incoming_call, :initiated)

      freeze_time do
        travel_to 1.minute.ago
        call.transition_to(:in_progress)
        travel_back
        call.transition_to(:completed)
      end

      expect(call.duration).to eq(60)
    end

    it "notifies stats of the call when it is completed" do
      call = create(:incoming_call, :in_progress)

      expect {
        call.transition_to(:completed)
      }.to have_enqueued_job(StatsCallNotificationJob)
    end
  end

  describe ".for_user" do
    it "finds calls for a user" do
      user = create(:user)
      call = create(:incoming_call, user: user)

      result = described_class.for_user(user)

      expect(result).to include(call)
    end
  end

  describe ".not_viewed" do
    it "finds calls that are not marked viewed" do
      call = create(:incoming_call, :not_viewed)

      result = described_class.not_viewed

      expect(result).to include(call)
    end
  end

  describe ".active" do
    it "returns all initiated calls" do
      active_call = create(:incoming_call)
      inactive_call = create(:incoming_call, :completed)

      result = described_class.active

      expect(result).to include(active_call)
      expect(result).not_to include(inactive_call)
    end

    it "returns all in_progress calls" do
      active_call = create(:incoming_call, :in_progress)
      inactive_call = create(:incoming_call, :completed)

      result = described_class.active

      expect(result).to include(active_call)
      expect(result).not_to include(inactive_call)
    end
  end

  describe ".answered" do
    it "returns all in_progress calls" do
      answered_call = create(:incoming_call, :in_progress)
      unanswered_call = create(:incoming_call, :no_answer)

      result = described_class.answered

      expect(result).to include(answered_call)
      expect(result).not_to include(unanswered_call)
    end

    it "returns all completed calls" do
      answered_call = create(:incoming_call, :completed)
      unanswered_call = create(:incoming_call, :no_answer)

      result = described_class.answered

      expect(result).to include(answered_call)
      expect(result).not_to include(unanswered_call)
    end
  end

  describe ".in_progress" do
    it "returns all in_progress calls" do
      in_progress_call = create(:incoming_call, :in_progress)
      completed_call = create(:incoming_call, :completed)

      result = described_class.in_progress

      expect(result).to include(in_progress_call)
      expect(result).not_to include(completed_call)
    end
  end

  describe ".by_identifier!" do
    it "finds call by SID" do
      call = create(:incoming_call, sid: "test")

      result = Call.by_identifier!(call.sid)

      expect(result).to eql(call)
    end

    it "finds call by Call ID" do
      call = create(:incoming_call)

      result = Call.by_identifier!(call.id)

      expect(result).to eql(call)
    end

    it "throws a exception if a call is not found" do
      expect {
        Call.by_identifier!("something")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe ".missed" do
    it "returns calls that are missed" do
      missed_call = create(:incoming_call, :no_answer)
      completed_call = create(:incoming_call, :completed)
      outgoing_call = create(:outgoing_call, :no_answer)

      result = described_class.missed

      expect(result).to include(missed_call)
      expect(result).not_to include(completed_call)
      expect(result).not_to include(outgoing_call)
    end

    it "returns calls that are not missed" do
      missed_call = create(:incoming_call, :no_answer)
      completed_call = create(:incoming_call, :completed)
      outgoing_call = create(:outgoing_call, :no_answer)

      result = described_class.missed(false)

      expect(result).not_to include(missed_call)
      expect(result).to include(completed_call)
      expect(result).to include(outgoing_call)
    end
  end

  describe ".statuses" do
    it "returns all call statuses" do
      result = described_class.statuses

      expect(result).to include("initiated")
      expect(result).to include("in_progress")
    end
  end

  describe "mark_viewed" do
    it "marks all not viewed calls as viewed" do
      user = create(:user)
      call = create(:incoming_call, :not_viewed, user: user)

      described_class.mark_viewed

      call.reload
      expect(call.viewed?).to be(true)
    end

    it "queues a broadcast count job" do
      user = create(:user)
      create(:incoming_call, :not_viewed, user: user)

      expect {
        described_class.mark_viewed
      }.to have_enqueued_job(BroadcastCountsJob)
    end
  end

  describe ".with_contact_phone_number" do
    it "gets calls with the specified phone number" do
      contact = create(:contact, phone_number: "+11231231234")
      participant = create(:participant, contact: contact)
      call = create(:incoming_call, participants: [participant])

      result = described_class.with_contact_phone_number("+11231231234")

      expect(result).to include(call)
    end
  end

  describe ".for_contact" do
    it "gets calls for a specific contact" do
      contact = create(:contact)
      participant = create(:participant, contact: contact)
      call = create(:incoming_call, participants: [participant])
      create(:incoming_call)

      result = described_class.for_contact(contact)

      expect(result.count).to eq(1)
      expect(result).to include(call)
    end
  end

  describe ".recorded" do
    it "gets calls that are marked recorded" do
      recorded_call = create(:incoming_call, :recorded)
      unrecorded_call = create(:incoming_call, recorded: false)

      result = Call.recorded

      expect(result).to include(recorded_call)
      expect(result).not_to include(unrecorded_call)
    end
  end

  describe "#active_participants?" do
    it "returns true if a call has particpants that are active" do
      call = create(:incoming_call)
      create(:participant, call: call, status: :in_progress)

      result = call.active_participants?

      expect(result).to be(true)
    end

    it "returns false if a call has no active participants" do
      call = build_stubbed(:incoming_call)

      result = call.active_participants?

      expect(result).to be(false)
    end
  end

  describe "#active?" do
    it "returns true if the call is in_progress" do
      call = build_stubbed(:call, :in_progress)

      result = call.active?

      expect(result).to be(true)
    end

    it "returns true if the call is initiated" do
      call = build_stubbed(:call, :initiated)

      result = call.active?

      expect(result).to be(true)
    end

    describe "#completed?" do
      it "returns true when the call is completed" do
        call = build_stubbed(:call, :completed)

        result = call.completed?

        expect(result).to be(true)
      end

      it "returns true when the call is in any other state" do
        call = build_stubbed(:call, :initiated)

        result = call.completed?

        expect(result).to be(false)
      end
    end

    it "returns false if the call is not active" do
      call = build_stubbed(:call, :completed)

      result = call.active?

      expect(result).to be(false)
    end
  end

  describe "#original_participant" do
    it "returns the oldest participant" do
      call = create(:incoming_call)
      create(:participant, call: call, created_at: 1.hour.ago)
      oldest_particpant = create(:participant, call: call, created_at: 2.hours.ago)

      result = call.original_participant

      expect(result).to eq(oldest_particpant)
    end
  end

  describe "#answered_at" do
    include ActiveSupport::Testing::TimeHelpers

    it "returns a timestamp for when the call transitioned to in_progress" do
      call = create(:incoming_call, :initiated)

      freeze_time do
        call.transition_to(:in_progress)

        expect(call.answered_at).to eq(Time.current)
      end
    end

    it "returns nil if the call was not answered" do
      call = build(:incoming_call)

      expect(call.answered_at).to be(nil)
    end
  end

  describe "#add_participant" do
    it "adds an existing contact as a participant to the call" do
      user = create(:user)
      contact = create(:contact, user: user)
      call = create(:incoming_call, user: user)

      participant = call.add_participant(phone_number: contact.phone_number, sid: "1234")

      expect(participant).to be_a(Participant)
      expect(participant.contact).to eq(contact)
      expect(participant.sid).to eq("1234")
    end

    it "creates a new contact and adds a participant to the call" do
      call = create(:incoming_call)

      participant = call.add_participant(phone_number: "+18282552550", sid: "1234")

      expect(participant).to be_a(Participant)
      expect(Contact.count).to eq(1)
    end

    it "marks call as internal if all participants are internal" do
      call = create(:incoming_call)
      user = create(:user_with_number)

      call.add_participant(phone_number: user.phone_number, sid: "1234")

      expect(call).to be_internal
    end

    it "does not mark call as internal if any participants are not internal" do
      call = create(:incoming_call, :with_participant)
      user = create(:user_with_number)

      call.add_participant(phone_number: user.phone_number, sid: "1234")

      expect(call).not_to be_internal
    end
  end

  describe "#toggle_recorded" do
    it "sets recorded to true if it was false" do
      call = create(:incoming_call, :in_progress, recorded: false)

      result = call.toggle_recorded

      expect(result).to be(true)
      expect(call.recorded).to be(true)
    end

    it "sets recorded to false if it was true" do
      call = create(:incoming_call, recorded: true)

      result = call.toggle_recorded

      expect(result).to be(true)
      expect(call.recorded).to be(false)
    end

    it "does not set recorded to true if the call is internal" do
      call = build_stubbed(:incoming_call, :in_progress, :internal, recorded: false)

      result = call.toggle_recorded

      expect(result).to be(false)
      expect(call.recorded).to be(false)
    end

    it "does not set recorded to true if the call is from an unrecordable phone number" do
      create(:unrecordable_phone_number, number: "+18282552550")
      contact = create(:contact, phone_number: "+18282552550")
      call = create(:incoming_call,
        :in_progress,
        :with_participant,
        user: contact.user,
        contact: contact)

      result = call.toggle_recorded

      expect(result).to be(false)
      expect(call.recorded).to be(false)
    end

    it "does not set recorded to true if the call is not active" do
      call = build_stubbed(:incoming_call, recorded: false)

      result = call.toggle_recorded

      expect(result).to be(false)
      expect(call.recorded).to be(false)
    end
  end

  describe "#save_recording?" do
    it "is true if the call is recordable" do
      call = build_stubbed(:incoming_call, internal: false)

      result = call.save_recording?

      expect(result).to be(true)
    end

    it "is true if the user is not recordable but they recorded the call" do
      user = build_stubbed(:user, recordable: false)
      call = build_stubbed(:incoming_call, user: user, recorded: true)

      result = call.save_recording?

      expect(result).to be(true)
    end

    it "is false if the call is not recordable" do
      call = build_stubbed(:incoming_call, internal: true)

      result = call.save_recording?

      expect(result).to be(false)
    end

    it "is false if the user is not recordable and the call was not explicitly recorded" do
      user = build_stubbed(:user, recordable: false)
      call = build_stubbed(:incoming_call, user: user, recorded: false)

      result = call.save_recording?

      expect(result).to be(false)
    end
  end

  describe "#recordable?" do
    it "is true if the phone number is not unrecordable and the call is not internal" do
      call = build_stubbed(:incoming_call)

      result = call.recordable?

      expect(result).to be(true)
    end

    it "is false if the phone number is unrecordable" do
      create(:unrecordable_phone_number, number: "+18282552550")
      contact = create(:contact, phone_number: "+18282552550")
      call = create(:incoming_call, :with_participant, user: contact.user, contact: contact)

      result = call.recordable?

      expect(result).to be(false)
    end

    it "is false if the call is internal" do
      call = build_stubbed(:incoming_call, :internal)

      result = call.recordable?

      expect(result).to be(false)
    end
  end

  describe "#owner?" do
    it "returns true for the user associated with the call" do
      user = build_stubbed(:user)
      call = build_stubbed(:incoming_call, user: user)

      result = call.owner?(user)

      expect(result).to be(true)
    end

    it "returns false for a user not associated with the call" do
      user = build_stubbed(:user)
      call = build_stubbed(:incoming_call)

      result = call.owner?(user)

      expect(result).to be(false)
    end
  end

  describe "#hangup" do
    it "ends the call" do
      call = build_stubbed(:incoming_call)
      end_call = stub_const("EndCall", spy(success?: true))

      result = call.hangup

      expect(result).to be(true)
      expect(end_call).to have_received(:call)
    end
  end
end
