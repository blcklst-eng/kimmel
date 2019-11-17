require "rails_helper"

RSpec.describe AssignPhoneNumber do
  describe "#call" do
    it "assigns a specified phone number to the user" do
      user = create(:user)
      phone_number = create(:phone_number, assignable: nil)

      result = described_class.new(user: user, phone_number: phone_number).call

      expect(result.success?).to be(true)
      expect(user.number).to eq(phone_number)
    end

    it "assigns a random phone number to the user" do
      user = create(:user)
      phone_number = create(:phone_number, assignable: nil)

      result = described_class.new(user: user).call

      expect(result.success?).to be(true)
      expect(user.number).to eq(phone_number)
    end

    it "sends a welcome email" do
      user = create(:user)
      create(:phone_number, assignable: nil)

      result = perform_enqueued_jobs {
        described_class.new(user: user).call
      }

      delivery = ActionMailer::Base.deliveries.last
      expect(delivery.to).to include(result.user.email)
    end

    it "does not assign a number if no numbers are available" do
      user = create(:user)

      result = described_class.new(user: user).call

      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end
  end
end
