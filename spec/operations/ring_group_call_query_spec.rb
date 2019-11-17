require "rails_helper"

describe "Ring Group Call Query API", :graphql do
  describe "ringGroupCall" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          ringGroupCall(id: $id) {
            id
          }
        }
      GRAPHQL
    end

    it "gets the specified ring group call" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      call = create(:ring_group_call, ring_group: ring_group)

      result = execute query, as: user, variables: {
        id: call.id,
      }

      returned_call = result[:data][:ringGroupCall]
      expect(returned_call[:id]).to eql(call.id.to_s)
    end
  end

  describe "ringGroupCall voicemail" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          ringGroupCall(id: $id) {
            id
            voicemail {
              id
              url
            }
          }
        }
      GRAPHQL
    end

    it "gets the calls voicemail" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      call = create(:ring_group_call, ring_group: ring_group)
      voicemail = create(:voicemail, voicemailable: call)

      result = execute query, as: user, variables: {
        id: call.id,
      }

      voicemail_result = result[:data][:ringGroupCall][:voicemail]
      expect(voicemail_result[:id]).to eql(voicemail.id.to_s)
      expect(voicemail_result[:url]).not_to be(nil)
    end
  end

  describe "ringGroupCall answeredCall" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          ringGroupCall(id: $id) {
            id
            answeredCall {
              id
            }
          }
        }
      GRAPHQL
    end

    it "gets the answered call that resulted from the ring group call" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      ring_group_call = create(:ring_group_call, ring_group: ring_group)
      answered_call = create(:incoming_call, :completed, ring_group_call: ring_group_call)

      result = execute query, as: user, variables: {
        id: ring_group_call.id,
      }

      answered_call_result = result[:data][:ringGroupCall][:answeredCall]
      expect(answered_call_result[:id]).to eql(answered_call.id.to_s)
    end
  end
end
