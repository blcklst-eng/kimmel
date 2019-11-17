require "rails_helper"

RSpec.describe TwilioAdapter, external_api: true do
  describe "#lookup" do
    before(:all) do
      Twilio.configure do |config|
        config.account_sid = Rails.application.credentials.dig(:production, :twilio, :account_sid)
        config.auth_token = Rails.application.credentials.dig(:production, :twilio, :auth_token)
      end
    end

    it "fetches the provided number from twilio" do
      result = subject.lookup("(828) 251-9900")

      expect(result.phone_number).to eq("+18282519900")
    end

    it "returns false if the number is not valid" do
      result = subject.lookup("5555555")

      expect(result.valid?).to be(false)
    end

    after(:all) do
      Twilio.configure do |config|
        config.account_sid = Rails.application.credentials.dig(:test, :twilio, :account_sid)
        config.auth_token = Rails.application.credentials.dig(:test, :twilio, :auth_token)
      end
    end
  end

  describe "#send" do
    let(:valid_to) { "+18282519900" }
    let(:invalid_to) { "+15005550001" }
    let(:valid_from) { "+15005550006" }
    let(:invalid_from) { "+15005550001" }

    it "sends a text with valid params" do
      result = subject.send_message(
        to: valid_to,
        from: valid_from,
        body: "test",
        status_url: "http://abc.com"
      )

      expect(result.sent?).to eq(true)
      expect(result.error).to be(nil)
    end

    it "sends a text with media" do
      result = subject.send_message(
        to: valid_to,
        from: valid_from,
        status_url: "http://abc.com",
        media_url: "https://demo.twilio.com/owl.png"
      )

      expect(result.sent?).to eq(true)
      expect(result.error).to be(nil)
    end

    it "does not send a text with an invalid to number" do
      result = subject.send_message(
        to: invalid_to,
        from: valid_from,
        body: "test",
        status_url: "http://abc.com"
      )

      expect(result.sent?).to eq(false)
      expect(result.error).not_to be(nil)
    end

    it "does not send a text with an invalid from number" do
      result = subject.send_message(
        to: valid_to,
        from: invalid_from,
        body: "test",
        status_url: "http://abc.com"
      )

      expect(result.sent?).to eq(false)
      expect(result.error).not_to be(nil)
    end

    it "does not send a text without a body or media" do
      result = subject.send_message(
        to: valid_to,
        from: valid_from,
        body: nil,
        status_url: "http://abc.com"
      )

      expect(result.sent?).to eq(false)
      expect(result.error).not_to be(nil)
    end
  end

  describe "#create_call" do
    it "starts a call" do
      result = subject.create_call(
        to: "+14108675310",
        from: "+15005550006",
        url: "https://test.com"
      )

      expect(result.connected?).to be(true)
      expect(result.sid).not_to be(nil)
    end

    it "returns false if a problem occurs" do
      result = subject.create_call(
        to: "+15005550001",
        from: "+15005550006",
        url: "https://test.com"
      )

      expect(result.connected?).to be(false)
      expect(result.error).not_to be_nil
    end
  end

  describe "#end_conference" do
    it "sets the status of the conference matching the sid to completed" do
      conference_spy = spy
      stub_const("Twilio::REST::Client", spy(conferences: conference_spy))

      subject.end_conference("123")

      expect(conference_spy).to have_received(:update).with(status: "completed")
    end

    it "returns false if the sid does not match any conferences" do
      result = subject.end_conference("123")

      expect(result).to be(false)
    end
  end

  describe "#update_call" do
    it "updates the specified call to point to the new url" do
      client = stub_const("Twilio::REST::Client", spy)

      result = subject.update_call(
        sid: "1234",
        url: "https://google.com",
        method: "POST"
      )

      expect(result).to be(true)
      expect(client).to have_received(:calls).with("1234")
      expect(client).to have_received(:update).with(url: "https://google.com", method: "POST")
    end

    it "returns false when updating the call fails" do
      result = subject.update_call(
        sid: "1234",
        url: "https://google.com",
        method: "POST"
      )

      expect(result).to be(false)
    end
  end

  describe "#cancel_call" do
    it "cancels a call" do
      client = stub_const("Twilio::REST::Client", spy(update: double(status: "canceled")))

      result = subject.cancel_call("1234")

      expect(result).to be(true)
      expect(client).to have_received(:calls).with("1234")
      expect(client).to have_received(:update).with(status: "canceled")
    end

    it "completes the call if the cancel fails" do
      client = stub_const("Twilio::REST::Client", spy(update: double(status: "in-progress")))

      result = subject.cancel_call("1234")

      expect(result).to be(true)
      expect(client).to have_received(:update).with(status: "completed")
    end

    it "returns false when updating the call fails" do
      result = subject.end_call("1234")

      expect(result).to be(false)
    end
  end

  describe "#end_call" do
    it "ends a call" do
      client = stub_const("Twilio::REST::Client", spy)

      result = subject.end_call("1234")

      expect(result).to be(true)
      expect(client).to have_received(:calls).with("1234")
      expect(client).to have_received(:update).with(status: "completed")
    end

    it "returns false when updating the call fails" do
      result = subject.end_call("1234")

      expect(result).to be(false)
    end
  end

  describe "#update_conference_participant" do
    it "updates the specified partifipant of a conference" do
      client = stub_const("Twilio::REST::Client", spy)

      result = subject.update_conference_participant("test", "fakeSid", params: {test: "test"})

      expect(result).to be(true)
      expect(client).to have_received(:conferences).with("test")
      expect(client).to have_received(:participants).with("fakeSid")
      expect(client).to have_received(:update).with(test: "test")
    end

    it "returns false when it fails to update" do
      result = subject.update_conference_participant("test", "fakeSid")

      expect(result).to be(false)
    end
  end

  describe "#request" do
    it "returns the body when succesful" do
      fake_client = spy(to_json: '{ "body": { "sid": "FAKESID123" } }')
      stub_const("Twilio::REST::Client", fake_client)

      result = subject.request("api.twilio.com/fake/recording/url")

      expect(result.success?).to be(true)
      expect(result.body).to include("sid" => "FAKESID123")
      expect(fake_client).to have_received(:request)
        .with("api.twilio.com", "80", "GET", "api.twilio.com/fake/recording/url")
    end

    it "returns failure when it could not fetch the url" do
      fake_client = stub_const("Twilio::REST::Client", spy)
      fake_response = Twilio::Response.new "300", {}
      fake_rest_error = Twilio::REST::RestError.new "Fake Message", fake_response
      allow(fake_client).to receive(:request).and_raise(fake_rest_error)

      result = subject.request("https://api.twilio.com/fake/recording/url")

      expect(result.success?).to be(false)
    end
  end
end
