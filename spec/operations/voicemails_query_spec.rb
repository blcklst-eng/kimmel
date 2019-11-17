require "rails_helper"

describe "Voicemails Query API", :graphql do
  describe "voicemails" do
    let(:query) do
      <<~'GRAPHQL'
        query($archived: Boolean) {
          voicemails(archived: $archived) {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the voicemails for the current user" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, voicemailable: call)
      another_voicemail = create(:voicemail)

      result = execute query, as: user

      nodes = result[:data][:voicemails][:edges].pluck(:node)
      expect(nodes).to include(id: voicemail.id.to_s)
      expect(nodes).not_to include(id: another_voicemail.id.to_s)
    end

    it "gets archived voicemails" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, :archived, voicemailable: call)
      another_call = create(:incoming_call, user: user)
      another_voicemail = create(:voicemail, archived: false, voicemailable: another_call)

      result = execute query, as: user, variables: {
        archived: true,
      }

      nodes = result[:data][:voicemails][:edges].pluck(:node)
      expect(nodes).to include(id: voicemail.id.to_s)
      expect(nodes).not_to include(id: another_voicemail.id.to_s)
    end
  end
end
