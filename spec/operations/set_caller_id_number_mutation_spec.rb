require "rails_helper"

describe "Set Caller Id Number Muation API", :graphql do
  describe "setCallerIdNumber" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: SetCallerIdNumberInput!) {
          setCallerIdNumber(input: $input) {
            user {
              callerIdNumber
            }
          }
        }
      GRAPHQL
    end

    it "sets a caller id number for the user" do
      phone_number = "+18282555500"
      stub_const("TwilioAdapter", spy(lookup: LookupResult.new(phone_number: phone_number)))
      user = create(:user_with_number)

      result = execute query, as: build(:user, :admin), variables: {
        input: {
          userId: user.id,
          phoneNumber: phone_number,
        },
      }

      caller_id_number_result = result[:data][:setCallerIdNumber][:user][:callerIdNumber]
      expect(caller_id_number_result).to eq(phone_number)
      expect(user.reload.caller_id_number).to eq(phone_number)
    end
  end
end
