require "rails_helper"

describe "Merge Call API", :graphql do
  describe "mergeCall" do
    let(:query) do
      <<-GRAPHQL
        mutation($input: MergeCallInput!) {
          mergeCall(input: $input) {
            participants {
              sid
            }
          }
        }
      GRAPHQL
    end

    it "moves participants from one call into another" do
      stub_const("TwilioAdapter", spy(update_call: true))

      user = create(:user)
      from_call = create(:incoming_call, :in_progress, user: user)
      participant = create(:participant, call: from_call)
      to_call = create(:incoming_call, :in_progress, :with_participant, user: user)

      result = execute query, as: user, variables: {
        input: {
          fromCallId: from_call.id,
          toCallId: to_call.id,
        },
      }

      participants_result = result[:data][:mergeCall][:participants]
      expect(participants_result).to include(sid: participant.sid)
      expect(to_call.participants.count).to eq(2)
      expect(to_call.participants).to include(
        an_object_having_attributes(sid: participant.sid, call_id: to_call.id)
      )
    end
  end
end
