require "rails_helper"

describe "View Voicemail Mutation API", :graphql do
  describe "viewVoicemail" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: ViewVoicemailInput!) {
          viewVoicemail(input: $input) {
            voicemail {
              viewed
            }
          }
        }
      GRAPHQL
    end

    it "updates a voicemail as viewed" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, :not_viewed, voicemailable: call)

      result = execute query, as: user, variables: {
        input: {
          id: voicemail.id,
        },
      }

      voicemail.reload
      viewed = result[:data][:viewVoicemail][:voicemail][:viewed]
      expect(voicemail.viewed?).to be(true)
      expect(viewed).to be(true)
    end

    it "broadcasts counts when a voicemail is viewed" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, :not_viewed, voicemailable: call)

      expect {
        execute query, as: user, variables: {
          input: {
            id: voicemail.id,
          },
        }
      }.to have_enqueued_job(BroadcastCountsJob)
    end
  end
end
