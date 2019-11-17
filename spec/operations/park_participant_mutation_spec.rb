require "rails_helper"

describe "Park Participant API", :graphql do
  describe "parkParticipant" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: ParkParticipantInput!) {
          parkParticipant(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "creates a call for a user and places the participant on hold" do
      fake_adapter = stub_const("TwilioAdapter", spy)
      operator = create(:user)
      user = create(:user)
      participant = create(:participant)
      create(:incoming_call, participants: [participant], user: operator)

      result = execute query, as: operator, variables: {
        input: {
          participantId: participant.id,
          userId: user.id,
        },
      }

      expect(result[:data][:parkParticipant][:success]).to be(true)
      expect(Call.for_user(user).count).to eq(1)
      expect(fake_adapter).to have_received(:update_call)
    end
  end
end
