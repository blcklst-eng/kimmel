require "rails_helper"

describe "Recording Query API", :graphql do
  describe "recording" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          recording(id: $id) {
            id
            url
          }
        }
      GRAPHQL
    end

    it "gets the specified recording" do
      user = create(:user)
      call = create(:incoming_call, user: user, recorded: true)
      recording = create(:recording, call: call)

      result = execute query, as: user, variables: {id: recording.id}

      recording_result = result[:data][:recording]
      expect(recording_result[:id]).to eq(recording.id.to_s)
      expect(recording_result[:url]).not_to be(nil)
    end
  end
end
