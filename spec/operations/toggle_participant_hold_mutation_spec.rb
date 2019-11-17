require "rails_helper"

describe "Toggle Participant Hold Mutation API", :graphql do
  describe "toggleParticipantHold" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: ToggleParticipantHoldInput!) {
          toggleParticipantHold(input: $input) {
            participant {
              onHold
            }
          }
        }
      GRAPHQL
    end

    it "puts a participant on hold" do
      stub_const("TwilioAdapter", spy)
      user = build(:user)
      call = build(:incoming_call, user: user)
      caller = create(:participant, call: call, on_hold: false)

      execute query, as: user, variables: {
        input: {
          participantId: caller.id,
        },
      }

      caller.reload
      expect(caller.on_hold?).to be(true)
    end

    it "removes a participant from hold" do
      stub_const("TwilioAdapter", spy)
      user = build(:user)
      call = build(:incoming_call, user: user)
      caller = create(:participant, call: call, on_hold: true)

      execute query, as: user, variables: {
        input: {
          participantId: caller.id,
        },
      }

      caller.reload
      expect(caller.on_hold?).to be(false)
    end
  end
end
