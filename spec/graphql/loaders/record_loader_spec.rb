require "rails_helper"

RSpec.describe Loaders::RecordLoader, type: :model do
  it "can load a record" do
    user = create(:user)
    loaded_user = GraphQL::Batch.batch {
      described_class.for(User).load(user.id)
    }
    expect(loaded_user.id).to eq(user.id)
  end
end
