require "rails_helper"

describe "Counts Query API", :graphql do
  describe "counts" do
    let(:query) do
      <<-'GRAPHQL'
        query {
          counts {
            missedCalls
            unreadConversations
            newVoicemails
          }
        }
      GRAPHQL
    end

    it "returns counts" do
      user = create(:user_with_number)
      call = create(:incoming_call, :not_viewed, user: user)
      create(:conversation, :unread, user: user)
      create(:voicemail, :not_viewed, voicemailable: call)

      result = execute query, as: user

      missed_calls = result[:data][:counts][:missedCalls]
      unread_conversations = result[:data][:counts][:unreadConversations]
      new_voicemails = result[:data][:counts][:newVoicemails]
      expect(missed_calls).to eq(1)
      expect(unread_conversations).to eq(1)
      expect(new_voicemails).to eq(1)
    end
  end
end
