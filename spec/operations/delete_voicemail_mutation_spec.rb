require "rails_helper"

describe "Delete Voicemail Mutation API", :graphql do
  let(:query) do
    <<-GRAPHQL
      mutation($input: DeleteVoicemailInput!) {
        deleteVoicemail(input: $input) {
          success
        }
      }
    GRAPHQL
  end

  it "deletes a voicemail" do
    voicemail = create(:voicemail)

    result = execute query, as: build(:user, :admin), variables: {
      input: {
        id: voicemail.id,
      },
    }

    expect(result[:data][:deleteVoicemail][:success]).to be(true)
    expect(voicemail.reload.deleted_at).not_to be(nil)
  end
end
