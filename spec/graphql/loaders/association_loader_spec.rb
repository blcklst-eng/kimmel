require "rails_helper"

RSpec.describe Loaders::AssociationLoader, type: :model do
  it "can load an association" do
    user = build_stubbed(:user)
    conversation = build_stubbed(:conversation, user: user)
    loaded_user = GraphQL::Batch.batch {
      described_class.for(Conversation, :user).load(conversation)
    }
    expect(loaded_user.id).to eq(user.id)
  end

  it "fails if trying to load for an object that does not match the class" do
    expect {
      GraphQL::Batch.batch do
        described_class.for(Conversation, :user).load(OpenStruct.new)
      end
    }.to raise_error(TypeError)
  end
end
