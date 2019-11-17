require "rails_helper"

RSpec.describe BroadcastUserAvailabilityJob, type: :job do
  it "triggers a graphql subscription" do
    schema = stub_const("MessagingSchema", spy)
    user = create(:user, available: true)

    described_class.new.perform(user.id)

    expect(schema).to have_received(:trigger)
  end
end
