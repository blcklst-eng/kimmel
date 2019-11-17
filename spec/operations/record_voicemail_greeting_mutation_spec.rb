require "rails_helper"

describe "Record Voicemail Greeting Mutation API", :graphql, :active_storage do
  describe "recordVoicemailGreeting" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: RecordVoicemailGreetingInput!) {
          recordVoicemailGreeting(input: $input) {
            user {
              voicemailGreetingUrl
            }
          }
        }
      GRAPHQL
    end

    it "uploads an audio file to use as a voicemail greeting" do
      user = create(:user)
      blob = create_audio_blob

      result = execute query, as: user, variables: {
        input: {
          audio: blob.signed_id,
        },
      }

      expect(user.voicemail_greeting).to be_attached
      result = result[:data][:recordVoicemailGreeting][:user]
      expect(result[:voicemailGreetingUrl]).not_to be_nil
    end
  end
end
