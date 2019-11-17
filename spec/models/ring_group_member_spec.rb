require "rails_helper"

RSpec.describe RingGroupMember, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:ring_group_member)).to be_valid
    end

    it "is not valid to be available if the user is not available" do
      user = build_stubbed(:user, available: false)
      member = build_stubbed(:ring_group_member, :available, user: user)

      expect(member).not_to be_valid
    end
  end

  context "callbacks" do
    describe "after_commit" do
      it "broadcasts that available has changed" do
        member = create(:ring_group_member, available: true)

        expect {
          member.update(available: false)
        }.to have_enqueued_job(BroadcastRingGroupMemberAvailabilityJob)
      end

      it "does not broadcast if available has not changed" do
        member = create(:ring_group_member, available: true)

        expect {
          member.update(available: true)
        }.not_to have_enqueued_job(BroadcastRingGroupMemberAvailabilityJob)
      end
    end
  end

  describe "#available" do
    it "returns all available members" do
      available_member = create(:ring_group_member, :available)
      unavailable_member = create(:ring_group_member, :unavailable)

      result = described_class.available

      expect(result).to include(available_member)
      expect(result).not_to include(unavailable_member)
    end
  end
end
