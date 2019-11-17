require "rails_helper"

RSpec.describe BroadcastMessageJob, type: :job do
  it "triggers a graphql subscription" do
    schema = stub_const("MessagingSchema", spy)
    message = create(:incoming_message)

    described_class.new.perform(message.id)

    expect(schema).to have_received(:trigger).twice
  end
end
