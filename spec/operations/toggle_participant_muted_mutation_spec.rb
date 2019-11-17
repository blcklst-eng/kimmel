require "rails_helper"

describe "Toggle Participant Muted Mutation API", :graphql do
  describe "toggleParticipantMuted" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: ToggleParticipantMutedInput!) {
          toggleParticipantMuted(input: $input) {
            participant {
              muted
            }
          }
        }
      GRAPHQL
    end

    it "mutes a participant that is not" do
      stub_const("TwilioAdapter", fake_adapter)
      user = build(:user)
      call = build(:incoming_call, user: user)
      caller = create(:participant, call: call, muted: false)

      execute query, as: user, variables: {
        input: {
          participantId: caller.id,
        },
      }

      caller.reload
      expect(caller.muted?).to be(true)
    end

    it "unmutes a participant that is muted" do
      stub_const("TwilioAdapter", fake_adapter)
      user = build(:user)
      call = build(:incoming_call, user: user)
      caller = create(:participant, call: call, muted: true)

      execute query, as: user, variables: {
        input: {
          participantId: caller.id,
        },
      }

      caller.reload
      expect(caller.muted?).to be(false)
    end
  end

  def fake_adapter
    spy(
      hold_conference_participant: true
    )
  end
end
