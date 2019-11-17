require "rails_helper"

RSpec.describe "Update Availability Mutation API", :graphql do
  describe "UpdateAvailability" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: UpdateAvailabilityInput!) {
          updateAvailability(input: $input) {
            user {
              available
              availabilityNote
            }
          }
        }
      GRAPHQL
    end

    it "updates the available settings for the current user" do
      user = create(:user_with_number, available: false)

      result = execute query, as: user, variables: {
        input: {
          id: user.id,
          availabilityInput: {
            available: true,
            availabilityNote: "Do not disturb",
          },
        },
      }

      returned_user = result[:data][:updateAvailability][:user]
      expect(returned_user[:available]).to be(true)
      expect(user.reload.available).to be(true)
      expect(returned_user[:availabilityNote]).to eq("Do not disturb")
      expect(user.reload.availability_note).to eq("Do not disturb")
    end
  end
end
