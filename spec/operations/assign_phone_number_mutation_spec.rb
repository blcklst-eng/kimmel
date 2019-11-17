require "rails_helper"

describe "Assign Phone Number Mutation API", :graphql do
  describe "assignPhoneNumber" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: AssignPhoneNumberInput!) {
          assignPhoneNumber(input: $input) {
            user {
              phoneNumber
            }
          }
        }
      GRAPHQL
    end

    it "randomly assigns a phone number to the specified user" do
      user = create(:user, abilities: [:manage_messaging])
      phone_number = create(:phone_number)

      result = execute query, as: user, variables: {
        input: {
          userId: user.id,
        },
      }

      number = result[:data][:assignPhoneNumber][:user][:phoneNumber]
      expect(number).to eq(phone_number.number)
      expect(phone_number.reload.user).to eq(user)
    end

    it "assigns the specified phone number to the specified user" do
      user = create(:user, abilities: [:manage_messaging])
      phone_number = create(:phone_number)

      result = execute query, as: user, variables: {
        input: {
          userId: user.id,
          phoneNumberId: phone_number.id,
        },
      }

      number = result[:data][:assignPhoneNumber][:user][:phoneNumber]
      expect(number).to eq(phone_number.number)
      expect(phone_number.reload.user).to eq(user)
    end
  end
end
