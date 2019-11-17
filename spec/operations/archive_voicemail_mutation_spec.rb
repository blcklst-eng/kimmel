require "rails_helper"

describe "Archive Voicemail Mutation API", :graphql do
  describe "archiveVoicemail" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: ArchiveVoicemailInput!) {
          archiveVoicemail(input: $input) {
            voicemail {
              id
              archived
            }
          }
        }
      GRAPHQL
    end

    it "archives a selected voicemail" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, voicemailable: call, archived: false)

      result = execute query, as: user, variables: {
        input: {
          id: voicemail.id,
        },
      }

      archived = result[:data][:archiveVoicemail][:voicemail][:archived]
      expect(archived).to be(true)
    end
  end
end
