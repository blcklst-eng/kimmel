require "rails_helper"

describe "End Participant Call Mutation API", :graphql do
  describe "endParticipantCall" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: EndParticipantCallInput!) {
          endParticipantCall(input: $input) {
            participant {
              status
            }
          }
        }
      GRAPHQL
    end

    it "removes a participant from a call" do
      stub_const("TwilioAdapter", spy)
      user = create(:user)
      call = create(:incoming_call, user: user)
      participant = create(:participant, :in_progress, call: call)

      result = execute query, as: user, variables: {
        input: {
          participantId: participant.id,
        },
      }

      participant_result = result[:data][:endParticipantCall][:participant]
      expect(participant_result[:status]).to eq("COMPLETED")
      expect(participant.reload).to be_completed
    end
  end
end
