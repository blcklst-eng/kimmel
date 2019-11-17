require "rails_helper"

describe "Recordings Query API", :graphql do
  describe "recordings" do
    let(:query) do
      <<~'GRAPHQL'
        query {
          recordings {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the recordings for the current user" do
      user = create(:user)
      call = create(:incoming_call, user: user, recorded: true)
      recording = create(:recording, call: call)
      another_recording = create(:recording)

      result = execute query, as: user

      nodes = result[:data][:recordings][:edges].pluck(:node)
      expect(nodes).to include(id: recording.id.to_s)
      expect(nodes).not_to include(id: another_recording.id.to_s)
    end
  end
end
