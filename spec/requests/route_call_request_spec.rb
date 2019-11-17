require "rails_helper"

RSpec.describe "Route Call API", :as_twilio, type: :request do
  describe "POST #store" do
    context "with valid params" do
      it "calls the incoming call router" do
        call = create(:incoming_call)
        router = stub_const("RouteIncomingCall", spy)

        post route_call_url(call)

        expect(router).to have_received(:call)
      end

      it "calls the outgoing call router" do
        call = create(:outgoing_call)
        router = stub_const("RouteOutgoingCall", spy)

        post route_call_url(call)

        expect(router).to have_received(:call)
      end
    end
  end
end
