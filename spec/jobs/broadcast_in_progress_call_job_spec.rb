require "rails_helper"

RSpec.describe BroadcastInProgressCallJob, type: :job do
  it "triggers two graphql subscription" do
    schema = stub_const("MessagingSchema", spy)
    call = create(:incoming_call)

    described_class.new.perform(call.id)

    expect(schema).to have_received(:trigger).twice
  end
end
