shared_examples_for "an assignable" do
  it { expect(subject).to respond_to(:present?) }
  it { expect(subject).to respond_to(:receive_incoming_call) }
  it { expect(subject).to respond_to(:receive_transfer_request_call) }
  it { expect(subject).to respond_to(:last_communication_at) }
  it { expect(subject).to respond_to(:email_voicemails?) }
end
