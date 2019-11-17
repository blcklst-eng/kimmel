require "rails_helper"

describe "Send Participant To Voicemail Mutation API", :graphql do
  describe "sendParticipantToVoicemail" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: SendParticipantToVoicemailInput!) {
          sendParticipantToVoicemail(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "sends the participant to the users voicemail" do
      fake_adapter = stub_const("TwilioAdapter", spy)
      user = create(:user)
      call = create(:incoming_call, user: user)
      participant = create(:participant, call: call)
      voicemail_user = create(:user_with_number)

      result = execute query, as: user, variables: {
        input: {
          participantId: participant.id,
          userId: voicemail_user.id,
        },
      }

      success = result[:data][:sendParticipantToVoicemail][:success]
      expect(success).to be(true)
      call = Call.find_by(user: voicemail_user)
      expect(call.in_state?(:no_answer)).to be(true)
      expect(call.participants.first.sid).to eq(participant.sid)
      expect(fake_adapter).to have_received(:update_call).with(
        a_hash_including(
          sid: participant.sid,
          url: RouteHelper.voicemail_create_url(call)
        )
      )
    end
  end
end
