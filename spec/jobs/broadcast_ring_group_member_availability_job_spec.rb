require "rails_helper"

RSpec.describe BroadcastRingGroupMemberAvailabilityJob, type: :job do
  it "triggers a graphql subscription" do
    schema = stub_const("MessagingSchema", spy)
    member = create(:ring_group_member, available: true)

    described_class.new.perform(member.id)

    expect(schema).to have_received(:trigger).with(
      "ringGroupMemberAvailability",
      {ring_group_id: member.ring_group_id},
      member
    )
  end
end
