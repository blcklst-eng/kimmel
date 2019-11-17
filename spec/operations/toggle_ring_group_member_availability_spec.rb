require "rails_helper"

RSpec.describe "Toggle Ring Group Member Availability API", :graphql do
  describe "toggleRingGroupMemberAvailability" do
    let(:query) do
      <<-'GRAPHQL'
        mutation ($input: ToggleRingGroupMemberAvailabilityInput!) {
          toggleRingGroupMemberAvailability(input: $input) {
            ringGroupMember {
              available
            }
          }
        }
      GRAPHQL
    end

    it "changes the availability setting for the specified ring group membership" do
      user = create(:user)
      member = create(:ring_group_member, :available, user: user)

      result = execute query, as: user, variables: {
        input: {
          memberId: member.id,
        },
      }

      returned_member = result[:data][:toggleRingGroupMemberAvailability][:ringGroupMember]
      expect(returned_member[:available]).to be(false)
      member.reload
      expect(member.available?).to be(false)
    end
  end
end
