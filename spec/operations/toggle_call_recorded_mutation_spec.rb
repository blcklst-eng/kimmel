require "rails_helper"

RSpec.describe "Toggle Call Recorded API", :graphql do
  describe "toggleCallRecorded" do
    let(:query) do
      <<-'GRAPHQL'
        mutation ($input: ToggleCallRecordedInput!) {
          toggleCallRecorded(input: $input) {
            call {
              recorded
            }
          }
        }
      GRAPHQL
    end

    it "marks a call as recorded that was not recorded" do
      user = create(:user)
      call = create(:incoming_call, :in_progress, recorded: false, user: user)

      result = execute query, as: user, variables: {
        input: {
          callId: call.id,
        },
      }

      returned_call = result[:data][:toggleCallRecorded][:call]
      expect(returned_call[:recorded]).to be(true)
      call.reload
      expect(call.recorded?).to be(true)
    end

    it "marks a call that was not recorded as recorded" do
      user = create(:user)
      call = create(:incoming_call, :in_progress, recorded: true, user: user)

      result = execute query, as: user, variables: {
        input: {
          callId: call.id,
        },
      }

      returned_call = result[:data][:toggleCallRecorded][:call]
      expect(returned_call[:recorded]).to be(false)
    end
  end
end
