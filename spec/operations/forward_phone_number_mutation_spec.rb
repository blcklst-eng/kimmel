require "rails_helper"

describe "Forward Phone Number Mutation API", :graphql do
  describe "forwardPhoneNumber" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: ForwardPhoneNumberInput!) {
          forwardPhoneNumber(input: $input) {
            phoneNumber {
              user {
                id
              }
              forwarding
            }
          }
        }
      GRAPHQL
    end

    it "reassigns a phone number and turns forwarding on" do
      user = create(:user, :admin)
      phone_number = create(:phone_number, user: user, forwarding: false)
      new_user = create(:user)

      result = execute query, as: user, variables: {
        input: {
          id: phone_number.id,
          userId: new_user.id,
        },
      }

      user_result = result[:data][:forwardPhoneNumber][:phoneNumber][:user]
      expect(user_result[:id]).to eq(new_user.id.to_s)
      expect(user.reload.number).to be(nil)
      expect(new_user.forwarding_numbers).to include(phone_number)
      expect(phone_number.reload.forwarding).to be(true)
    end
  end
end
