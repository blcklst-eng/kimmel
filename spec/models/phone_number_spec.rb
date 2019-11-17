require "rails_helper"

RSpec.describe PhoneNumber, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:phone_number)).to be_valid
    end

    it { should validate_presence_of(:number) }

    it "is not valid with non-unique phone number" do
      create(:phone_number, number: "+11231231234")
      phone_number = build(:phone_number, number: "+11231231234")

      expect(phone_number).not_to be_valid
    end

    it "is not valid if the assignable already has a phone number" do
      ring_group = create(:ring_group)
      create(:phone_number, assignable: ring_group)
      duplicate_phone_number = build(:phone_number, assignable: ring_group)

      expect(duplicate_phone_number).not_to be_valid
    end

    it "is valid if the additional number is a forwarding number" do
      user = create(:user)
      create(:phone_number, assignable: user, forwarding: false)
      forwarding_number = build(:phone_number, assignable: user, forwarding: true)

      expect(forwarding_number).to be_valid
    end
  end

  context "callbacks" do
    describe "after_commit" do
      it "reindexs the assigned user" do
        expect {
          create(:phone_number, :with_user)
        }.to have_enqueued_job.on_queue("searchkick")
      end

      it "does not reindex if the phone number is not assigned to a user" do
        expect {
          create(:phone_number, assignable: nil)
        }.not_to have_enqueued_job.on_queue("searchkick")
      end
    end
  end

  describe ".unassigned" do
    it "can find unassigned phone numbers" do
      phone = create(:phone_number)

      result = described_class.unassigned

      expect(result).to include(phone)
    end

    it "does not find assigned phone numbers" do
      create(:phone_number, assignable: create(:ring_group))

      result = described_class.unassigned

      expect(result.count).to eq(0)
    end
  end

  describe ".forwarding" do
    it "can find forwarding phone numbers" do
      phone = create(:phone_number, forwarding: true)

      result = described_class.forwarding

      expect(result).to include(phone)
    end

    it "does not find non-forwarding phone numbers" do
      create(:phone_number, forwarding: false)

      result = described_class.forwarding

      expect(result.count).to eq(0)
    end

    it "can find non-forwarding phone numbers when passed a param" do
      phone = create(:phone_number, forwarding: false)

      result = described_class.forwarding(false)

      expect(result).to include(phone)
    end
  end

  describe ".send_ping_messages" do
    it "sends a ping message for numbers that need it" do
      user = create(:user_with_number)
      create(:incoming_call, user: user, created_at: PhoneNumber::PING_DATE.ago - 1.day)

      expect {
        PhoneNumber.send_ping_messages
      }.to have_enqueued_job
    end

    it "does not send ping messages for numbers that do not need it" do
      user = create(:user_with_number)
      create(:incoming_call, user: user, created_at: PhoneNumber::PING_DATE.ago + 1.day)

      expect {
        PhoneNumber.send_ping_messages
      }.not_to have_enqueued_job
    end

    it "sends ping message with phone numbers that have not had any communication" do
      create(:phone_number)

      expect {
        PhoneNumber.send_ping_messages
      }.to have_enqueued_job
    end
  end

  describe ".external?" do
    it "returns true for a number that we do not own" do
      result = PhoneNumber.external?("+18282552550")

      expect(result).to be(true)
    end

    it "returns false for an internal number" do
      phone_number = create(:phone_number)
      result = PhoneNumber.external?(phone_number.number)

      expect(result).to be(false)
    end
  end

  describe "#forward_to" do
    it "assigns a phone number to a user and turns forwarding on" do
      user = create(:user)
      phone_number = create(:phone_number, forwarding: false)

      result = phone_number.forward_to(user)

      expect(result).to be(true)
      expect(phone_number.user).to eq(user)
    end
  end

  describe "#assignable" do
    it "returns the assignable if present" do
      phone_number = build_stubbed(:phone_number, :with_user)

      result = phone_number.assignable

      expect(result).to be_a(User)
    end

    it "returns unassigned if the phone number does not have an assignable" do
      phone_number = build_stubbed(:phone_number, assignable: nil)

      result = phone_number.assignable

      expect(result).to be_a(Unassigned)
    end
  end
end
