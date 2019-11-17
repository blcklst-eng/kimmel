require "rails_helper"

describe CreateTransferRequestCall, type: :model do
  describe "#call" do
    it "connects a operator with a user" do
      fake_adapter = spy
      transfer_request = create(:transfer_request)

      result = described_class.new(transfer_request, adapter: fake_adapter).call

      expect(result.success?).to be(true)
      expect(fake_adapter).to have_received(:create_call).with(
        any_args,
        hash_including(
          to: transfer_request.requestor.incoming_connection,
          from: transfer_request.requestor.client
        )
      )
    end
  end

  def routes
    Rails.application.routes.url_helpers
  end
end
