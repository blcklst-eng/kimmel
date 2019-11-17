require "rails_helper"

RSpec.describe Recording, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(create(:recording)).to be_valid
    end

    it { should validate_numericality_of(:duration).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:sid) }

    it "is not valid without an audio file" do
      recording = build(:recording, audio: nil)

      expect(recording).not_to be_valid
    end
  end

  describe ".for_user" do
    it "finds recordings for the specified user" do
      user = create(:user)
      call = create(:incoming_call, user: user)
      recording = create(:recording, call: call)

      result = described_class.for_user(user).first

      expect(result).to eq(recording)
    end

    it "does not find recordings for other users" do
      user = create(:user)
      create(:recording)

      result = described_class.for_user(user).first

      expect(result).to be(nil)
    end
  end

  describe ".recorded" do
    it "finds recordings for calls that are marked recorded" do
      recorded_call = create(:incoming_call, :recorded)
      recording = create(:recording, call: recorded_call)
      unrecorded_call = create(:incoming_call, recorded: false)
      other_recording = create(:recording, call: unrecorded_call)

      result = described_class.recorded

      expect(result).to include(recording)
      expect(result).not_to include(other_recording)
    end
  end
end
