require "rails_helper"

RSpec.describe RejoinCall, type: :model do
  describe "#call" do
    it "dials the specified user into the call and updates the sid" do
      call_result = CallResult.new(connected?: true, sid: "fake-sid")
      adapter = spy(create_call: call_result)
      user = create(:user_with_number)
      call = create(:outgoing_call, :in_progress, user: user, sid: "1234")

      result = described_class.new(user: user, call: call, adapter: adapter).call

      expect(result.success?).to be(true)
      expect(adapter).to have_received(:create_call)
      expect(call.sid).to eq("fake-sid")
    end

    it "returns failure when it was not able to dial into the call" do
      call_result = CallResult.new(connected?: false, sid: "fake-sid")
      adapter = spy(create_call: call_result)
      user = create(:user_with_number)
      call = create(:outgoing_call, :in_progress, user: user, sid: "1234")

      result = described_class.new(user: user, call: call, adapter: adapter).call

      expect(result.success?).to be(false)
      expect(call.sid).not_to eq("fake-sid")
    end

    it "returns failure if the call is not active" do
      call_result = CallResult.new(connected?: true, sid: "fake-sid")
      adapter = spy(create_call: call_result)
      user = create(:user_with_number)
      call = create(:outgoing_call, :completed, user: user)

      result = described_class.new(user: user, call: call, adapter: adapter).call

      expect(result.success?).to be(false)
    end
  end
end
