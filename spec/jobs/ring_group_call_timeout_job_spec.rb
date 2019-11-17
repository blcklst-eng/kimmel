require "rails_helper"

RSpec.describe RingGroupCallTimeoutJob, type: :job do
  it "sends the ring group call to voicemail if it has timed out" do
    ring_group_call = create(:ring_group_call)
    timeout = stub_const("RingGroupCallTimedOut", spy)

    described_class.new.perform(ring_group_call.id)

    expect(timeout).to have_receive(:call)
  end
end
