require "rails_helper"

describe ReceiveTransferRequestCall, type: :model do
  describe "#call" do
    it "associates a call to the transfer request as request call" do
      user = create(:user_with_number)
      call = create(:incoming_call)
      stub_const("ReceiveCall", spy(call: Result.success(call: call)))
      transfer_request = create(:transfer_request)

      result = described_class.new(
        transfer_request: transfer_request,
        to: user.number,
        from: "+18282519900",
        sid: "1234"
      ).call

      expect(result.success?).to be(true)
      expect(transfer_request.reload.request_call).to eq(call)
    end
  end
end
