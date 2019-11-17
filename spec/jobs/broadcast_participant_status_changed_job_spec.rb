require "rails_helper"

RSpec.describe BroadcastParticipantStatusChangedJob, type: :job do
  it "triggers a graphql subscription" do
    schema = stub_const("MessagingSchema", spy)
    participant = create(:participant)

    described_class.new.perform(participant.id)

    expect(schema).to have_received(:trigger)
  end
end
