require "rails_helper"

RSpec.describe User, type: :model do
  it_should_behave_like "an assignable"

  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:user)).to be_valid
    end

    it { should validate_presence_of(:origin_id) }
    it { should validate_numericality_of(:origin_id).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:walter_id).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:intranet_id).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it "is not valid with a non-unique email" do
      user = create(:user)
      duplicate_user = build(:user, email: user.email)

      expect(duplicate_user).not_to be_valid
    end

    it "is not valid if call forwarding is enabled without a call forwarding number" do
      user = build(:user, call_forwarding: true, call_forwarding_number: nil)

      expect(user).not_to be_valid
    end

    it "is not valid if the voicemail greeting is not audio", :active_storage do
      user = build(:user, voicemail_greeting: create_blob(content_type: "text/plain"))

      expect(user).not_to be_valid
    end
  end

  context "callbacks" do
    describe "after_commit" do
      it "broadcasts that available has changed" do
        user = create(:user, available: true)

        expect { user.update(available: false) }.to have_enqueued_job(BroadcastUserAvailabilityJob)
      end

      it "broadcasts that the availability note has changed" do
        user = create(:user, availability_note: "Do not disturb")

        expect {
          user.update(availability_note: "Lunch")
        }.to have_enqueued_job(BroadcastUserAvailabilityJob)
      end

      it "does not broadcast if available has not changed" do
        user = create(:user, available: true)

        expect {
          user.update(available: true)
        }.not_to have_enqueued_job(BroadcastUserAvailabilityJob)
      end
    end
  end

  describe ".with_number" do
    it "only returns users with a phone number" do
      user_with = create(:user_with_number)
      user_without = create(:user)

      result = User.with_number

      expect(result).to include(user_with)
      expect(result).not_to include(user_without)
    end
  end

  describe ".order_by_name" do
    it "orders by last name in alphabetical order" do
      second_user = create(:user, last_name: "Smith")
      first_user = create(:user, last_name: "Doe")

      result = described_class.order_by_name

      expect(result.first).to eq(first_user)
      expect(result.second).to eq(second_user)
    end

    it "orders by first name when last names are the same" do
      second_user = create(:user, last_name: "Doe", first_name: "Martha")
      first_user = create(:user, last_name: "Doe", first_name: "Alan")

      result = described_class.order_by_name

      expect(result.first).to eq(first_user)
      expect(result.second).to eq(second_user)
    end
  end

  describe ".by_number" do
    it "returns nil if it cannot find a phone number" do
      expect(described_class.by_number("+12312121212")).to eq nil
    end

    it "returns nil if the phone number does not have a user" do
      create(:phone_number, number: "+11231231234")

      expect(described_class.by_number("+11231231234")).to eq nil
    end

    it "returns the user associated to a phone number" do
      user = create(:user)
      create(:phone_number, number: "+11231231234", user: user)

      expect(described_class.by_number("+11231231234")).to eq(user)
    end
  end

  describe "#active_calls?" do
    it "returns true if the user has active calls" do
      user = create(:user)
      create(:incoming_call, :in_progress, user: user)

      result = user.active_calls?

      expect(result).to be(true)
    end

    it "returns false if the user does not have active cals" do
      user = create(:user)

      result = user.active_calls?

      expect(result).to be(false)
    end
  end

  describe "#full_name" do
    it "returns the user's first_name and last_name" do
      user = build_stubbed(:user, first_name: "John", last_name: "Doe")

      result = user.full_name

      expect(result).to eq("John Doe")
    end
  end

  describe "#outgoing_number" do
    it "returns the user's number if the call is external and they don't have a caller id number" do
      user = build_stubbed(:user_with_number)
      call = build_stubbed(:outgoing_call, internal: false)

      result = user.outgoing_number(call)

      expect(result).to eq(user.phone_number)
    end

    it "returns the user's caller_id_number if the call is external" do
      user = build_stubbed(:user_with_number, :with_caller_id_number)
      call = build_stubbed(:outgoing_call, internal: false)

      result = user.outgoing_number(call)

      expect(result).to eq(user.caller_id_number)
    end

    it "returns the user's actual number if the call is internal" do
      phone_number = build_stubbed(:phone_number)
      user = build_stubbed(:user, :with_caller_id_number, number: phone_number)
      call = build_stubbed(:outgoing_call, :internal)

      result = user.outgoing_number(call)

      expect(result).to eq(phone_number.number)
    end
  end

  describe "#client" do
    it "returns a twilio client string" do
      user = create(:user)

      expect(user.client).to include("client:#{user.id}")
    end
  end

  describe "#incoming_connection" do
    it "returns the client when call forwarding is disabled" do
      user = create(:user, call_forwarding: false)

      expect(user.incoming_connection).to include(user.client)
    end

    it "returns the forwarding number when call forwarding is enabled" do
      user = create(:user, :forwarding)

      expect(user.incoming_connection).to include(user.call_forwarding_number)
    end
  end

  describe "#guest?" do
    it "returns false" do
      user = described_class.new

      result = user.guest?

      expect(result).to be(false)
    end
  end

  describe "#admin?" do
    it "returns true if the user has the manage_messaging ability" do
      user = described_class.new(abilities: [:manage_messaging])

      result = user.admin?

      expect(result).to be(true)
    end

    it "returns false if the user does not have the manage_messaging ability" do
      user = described_class.new(abilities: [])

      result = user.admin?

      expect(result).to be(false)
    end
  end

  describe "#see_calling?" do
    it "returns true if the user has the see_calling ability" do
      user = described_class.new(abilities: [:see_calling])

      result = user.see_calling?

      expect(result).to be(true)
    end

    it "returns false if the user does not have the see_calling ability" do
      user = described_class.new(abilities: [])

      result = user.see_calling?

      expect(result).to be(false)
    end
  end

  describe "#number?" do
    it "returns true if the user has a phone number" do
      user = build_stubbed(:user_with_number)

      result = user.number?

      expect(result).to be(true)
    end

    it "returns false if the user does not have a number" do
      user = create(:user)

      result = user.number?

      expect(result).to be(false)
    end
  end

  describe "#last_communication_at" do
    it "returns the time of the last message sent when it is more recent than the last call" do
      user = create(:user)
      conversation = create(:conversation, user: user)
      message = create(:incoming_message, conversation: conversation, created_at: 1.week.ago)
      create(:incoming_call, user: user, created_at: 2.weeks.ago)

      result = user.last_communication_at

      expect(result.to_i).to eq(message.created_at.to_i)
    end

    it "returns the time of the last call when it is more recent than the last message" do
      user = create(:user)
      conversation = create(:conversation, user: user)
      create(:incoming_message, conversation: conversation, created_at: 2.weeks.ago)
      call = create(:incoming_call, user: user, created_at: 1.week.ago)

      result = user.last_communication_at

      expect(result.to_i).to eq(call.created_at.to_i)
    end

    it "returns nil if the user has never had any communication" do
      user = build_stubbed(:user)

      result = user.last_communication_at

      expect(result).to be_nil
    end
  end

  describe "#receive_incoming_call" do
    it "passes along the phone number for the user" do
      user = build_stubbed(:user_with_number)
      receiver = stub_const("ReceiveCall", spy(call: Result.success))

      result = user.receive_incoming_call(
        from: "+18282519900",
        sid: "1234"
      )

      expect(result.success?).to be(true)
      expect(receiver).to have_received(:new).with(hash_including(to: user.number))
      expect(receiver).to have_received(:call)
    end

    it "passes along the screener number to an available screener" do
      user = build_stubbed(:user_with_number, :with_screener)
      receiver = stub_const("ReceiveCall", spy(call: Result.success))

      result = user.receive_incoming_call(
        from: "+18282519900",
        sid: "1234"
      )

      expect(result.success?).to be(true)
      expect(receiver).to have_received(:new).with(hash_including(to: user.screener_number))
      expect(receiver).to have_received(:call)
    end

    it "does not screen if the screener is unavailable" do
      unavailable_screener = build_stubbed(
        :phone_number,
        assignable: build_stubbed(:user, :unavailable)
      )
      user = build_stubbed(:user_with_number, screener_number: unavailable_screener)
      receiver = stub_const("ReceiveCall", spy(call: Result.success))

      result = user.receive_incoming_call(
        from: "+18282519900",
        sid: "1234"
      )

      expect(result.success?).to be(true)
      expect(receiver).to have_received(:new).with(hash_including(to: user.number))
      expect(receiver).to have_received(:call)
    end

    it "passes along the user number when the call is from another user" do
      user = build_stubbed(:user_with_number, :with_screener)
      other_user = create(:user_with_number)
      receiver = stub_const("ReceiveCall", spy(call: Result.success))

      result = user.receive_incoming_call(
        from: other_user.phone_number,
        sid: "1234"
      )

      expect(result.success?).to be(true)
      expect(receiver).to have_received(:new).with(hash_including(to: user.number))
      expect(receiver).to have_received(:call)
    end
  end

  describe "#update_availability" do
    it "updates available and availability_note" do
      user = build(:user, available: false)

      result = user.update_availability(available: true, availability_note: "test note")

      expect(result).to be(true)
      expect(user).to be_available
      expect(user.availability_note).to eq("test note")
    end

    it "uses existing values if they are not passed" do
      user = build(:user, available: false, availability_note: "test note")

      result = user.update_availability(available: true)

      expect(result).to be(true)
      expect(user).to be_available
      expect(user.availability_note).to eq("test note")
    end

    it "sets the user to unavailable in any ring groups if the user goes unavailable" do
      user = create(:user, available: true)
      membership = create(:ring_group_member, :available, user: user)

      user.update_availability(available: false)

      expect(user).not_to be_available
      expect(membership.reload).not_to be_available
    end
  end

  describe "#abilities" do
    it "returns users abilities" do
      user = described_class.new(abilities: ["test"])

      result = user.abilities

      expect(result).to eq([:test])
    end

    it "defaults to an empty array" do
      user = described_class.new

      result = user.abilities

      expect(result).to eq([])
    end
  end

  describe "#abilities=" do
    it "assigns abilities to the user" do
      user = described_class.new

      user.abilities = %i[test test2]

      expect(user.abilities).to include(:test, :test2)
    end
  end

  describe "#can?" do
    it "returns true if the user has the ability to perform the specified action" do
      user = described_class.new(abilities: [:manage_messaging])

      can = user.can?(:manage_messaging)

      expect(can).to be(true)
    end

    it "returns false if the user does not have the ability to perform the specified action" do
      user = described_class.new

      can = user.can?(:do_anything)

      expect(can).to be(false)
    end
  end
end
