require "rails_helper"

describe "Set Email Voicemails Mutation API", :graphql do
  describe "setEmailVoicemails" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: SetEmailVoicemailsInput!) {
          setEmailVoicemails(input: $input) {
            user {
              emailVoicemails
            }
          }
        }
      GRAPHQL
    end

    it "sets email voicemails" do
      user = create(:user, email_voicemails: false)

      execute query, as: user, variables: {
        input: {
          emailVoicemails: true,
        },
      }

      expect(user.reload.email_voicemails?).to be(true)
    end
  end
end
