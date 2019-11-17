require "rails_helper"

describe "Voicemail Query API", :graphql do
  describe "voicemail" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          voicemail(id: $id) {
            id
            url
          }
        }
      GRAPHQL
    end

    it "gets the specified voicemail" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, voicemailable: call)

      result = execute query, as: user, variables: {id: voicemail.id}

      voicemail_result = result[:data][:voicemail]
      expect(voicemail_result[:id]).to eq(voicemail.id.to_s)
      expect(voicemail_result[:url]).not_to be(nil)
    end
  end

  describe "voicemail call" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          voicemail(id: $id) {
            id
            url
            call {
              ... on IncomingCall {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the specified voicemail and call" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      voicemail = create(:voicemail, voicemailable: call)

      result = execute query, as: user, variables: {id: voicemail.id}

      call_result = result[:data][:voicemail][:call]
      expect(call_result[:id]).to eq(call.id.to_s)
    end
  end
end
