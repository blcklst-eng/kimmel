require "rails_helper"

RSpec.describe BroadcastCountsJob, type: :job do
  describe "#perform" do
    it "triggers a graphql subscription" do
      schema = stub_const("MessagingSchema", spy)
      user = create(:user)

      described_class.new.perform(user.id)

      expect(schema).to have_received(:trigger)
    end
  end
end
