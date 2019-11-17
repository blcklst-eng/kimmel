require "rails_helper"

describe "Delete Recording Mutation API", :graphql do
  let(:query) do
    <<-GRAPHQL
      mutation($input: DeleteRecordingInput!) {
        deleteRecording(input: $input) {
          success
        }
      }
    GRAPHQL
  end

  it "deletes a recording" do
    user = create(:user)
    call = create(:incoming_call, user: user, recorded: true)
    recording = create(:recording, call: call)

    result = execute query, as: user, variables: {
      input: {
        id: recording.id,
      },
    }

    expect(result[:data][:deleteRecording][:success]).to be(true)
    expect(call.reload.recorded?).to be(false)
  end
end
