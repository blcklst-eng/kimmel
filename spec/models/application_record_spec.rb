require "rails_helper"

RSpec.describe ApplicationRecord, type: :model do
  describe ".latest" do
    it "orders records by the date they were created ascending" do
      first_record = create(:ring_group, created_at: 1.day.ago)
      second_record = create(:ring_group, created_at: 1.week.ago)

      result = RingGroup.latest

      expect(result.first).to eq(first_record)
      expect(result.second).to eq(second_record)
    end
  end
end
