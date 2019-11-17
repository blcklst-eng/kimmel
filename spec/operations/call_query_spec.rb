require "rails_helper"

describe "Call Query API", :graphql do
  describe "call" do
    let(:query) do
      <<-'GRAPHQL'
        query($identifier: String!) {
          call(identifier: $identifier) {
            id
          }
        }
      GRAPHQL
    end

    it "gets the specified call" do
      user = create(:user)
      call = create(:incoming_call, user: user)

      result = execute query, as: user, variables: {
        identifier: call.sid,
      }

      returned_call = result[:data][:call]
      expect(returned_call[:id]).to eql(call.id.to_s)
    end
  end

  describe "call originalParticipant" do
    let(:query) do
      <<-'GRAPHQL'
        query($identifier: String!) {
          call(identifier: $identifier) {
            id
            originalParticipant {
              id
            }
          }
        }
      GRAPHQL
    end

    it "gets the calls original participant" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      participant = create(:participant, call: call)

      result = execute query, as: user, variables: {
        identifier: call.sid,
      }

      original_participant_result = result[:data][:call][:originalParticipant]
      expect(original_participant_result[:id]).to eql(participant.id.to_s)
    end
  end

  describe "call recording" do
    let(:query) do
      <<-'GRAPHQL'
        query($identifier: String!) {
          call(identifier: $identifier) {
            id
            recording {
              id
              url
            }
          }
        }
      GRAPHQL
    end

    it "gets the calls recording" do
      user = create(:user)
      call = create(:incoming_call, user: user, recorded: true)
      recording = create(:recording, call: call)

      result = execute query, as: user, variables: {
        identifier: call.sid,
      }

      recording_result = result[:data][:call][:recording]
      expect(recording_result[:id]).to eql(recording.id.to_s)
      expect(recording_result[:url]).not_to be(nil)
    end
  end

  describe "call voicemail" do
    let(:query) do
      <<-'GRAPHQL'
        query($identifier: String!) {
          call(identifier: $identifier) {
            id
            ... on IncomingCall {
              voicemail {
                id
                url
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the calls voicemail" do
      user = create(:user)
      call = create(:incoming_call, user: user, recorded: true)
      voicemail = create(:voicemail, voicemailable: call)

      result = execute query, as: user, variables: {
        identifier: call.sid,
      }

      voicemail_result = result[:data][:call][:voicemail]
      expect(voicemail_result[:id]).to eql(voicemail.id.to_s)
      expect(voicemail_result[:url]).not_to be(nil)
    end
  end
end
