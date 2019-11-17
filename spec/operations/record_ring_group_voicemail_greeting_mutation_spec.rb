require "rails_helper"

describe "Record Ring Group Voicemail Greeting Mutation API", :graphql, :active_storage do
  describe "recordRingGroupVoicemailGreeting" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: RecordRingGroupVoicemailGreetingInput!) {
          recordRingGroupVoicemailGreeting(input: $input) {
            ringGroup {
              voicemailGreetingUrl
            }
          }
        }
      GRAPHQL
    end

    it "uploads an audio file to use as a voicemail greeting" do
      ring_group = create(:ring_group)
      blob = create_audio_blob

      result = execute query, as: build_stubbed(:user, :admin), variables: {
        input: {
          ringGroupId: ring_group.id,
          audio: blob.signed_id,
        },
      }

      expect(ring_group.reload.voicemail_greeting).to be_attached
      result = result[:data][:recordRingGroupVoicemailGreeting][:ringGroup]
      expect(result[:voicemailGreetingUrl]).not_to be_nil
    end
  end
end
