require "rails_helper"

describe "Toggle Call Quality Issue", :graphql do
  describe "toggleCallQualityIssue" do
    let(:query) do
      <<~GRAPHQL
        mutation($input: ToggleCallQualityIssueInput!) {
          toggleCallQualityIssue(input: $input) {
            call {
              qualityIssue
            }
          }
        }
      GRAPHQL
    end

    it "toggles the quality issue on call to true" do
      user = create(:user)
      call = create(:incoming_call, user: user, quality_issue: false)

      result = execute query, as: user, variables: {
        input: {
          callId: call.id,
        },
      }

      returned_call = result[:data][:toggleCallQualityIssue][:call]
      expect(returned_call[:qualityIssue]).to be(true)
      expect(call.reload.quality_issue?).to be(true)
    end

    it "toggles the quality issue on call to false" do
      user = create(:user)
      call = create(:incoming_call, user: user, quality_issue: true)

      result = execute query, as: user, variables: {
        input: {
          callId: call.id,
        },
      }

      returned_call = result[:data][:toggleCallQualityIssue][:call]
      expect(returned_call[:qualityIssue]).to be(false)
      expect(call.reload.quality_issue?).to be(false)
    end
  end
end
