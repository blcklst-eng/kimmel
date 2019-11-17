require "rails_helper"

describe "Viewed Calls Mutation API", :graphql do
  describe "viewedCalls" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: ViewedCallsInput!) {
          viewedCalls(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "marks all not viewed calls for user as viewed" do
      user = create(:user)
      call = create(:incoming_call, :not_viewed, user: user)
      other_call = create(:incoming_call, :not_viewed)

      result = execute query, as: user, variables: {
        input: {},
      }

      success = result[:data][:viewedCalls][:success]
      expect(success).to be(true)
      expect(call.reload.viewed?).to be(true)
      expect(other_call.reload.viewed?).not_to be(true)
    end

    it "marks all not viewed calls for user as viewed for a contact" do
      user = create(:user)
      contact = create(:contact, user: user)
      participant = create(:participant, contact: contact)
      call = create(:incoming_call, :not_viewed, user: user, participants: [participant])
      unviewed_call = create(:incoming_call, :not_viewed, user: user)

      result = execute query, as: user, variables: {
        input: {
          contactId: contact.id,
        },
      }

      success = result[:data][:viewedCalls][:success]
      expect(call.reload.viewed?).to be(true)
      expect(unviewed_call.reload.viewed?).to be(false)
      expect(success).to be(true)
    end
  end
end
