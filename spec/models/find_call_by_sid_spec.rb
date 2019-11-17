require "rails_helper"

RSpec.describe FindCallBySid, type: :model do
  describe "#find" do
    it "finds a call with the sid" do
      call = create(:incoming_call, sid: "1234")

      result = described_class.new(id: call.id, sid: "1234").find

      expect(result).to eq(call)
    end

    it "finds a call with a matching participant sid" do
      call = create(:incoming_call)
      create(:participant, call: call, sid: "1234")

      result = described_class.new(id: call.id, sid: "1234").find

      expect(result).to eq(call)
    end

    it "finds a ring group call with a matching sid" do
      ring_group_call = create(:ring_group_call, from_sid: "1234")

      result = described_class.new(id: ring_group_call.id, sid: "1234").find

      expect(result).to eq(ring_group_call)
    end

    it "throws a exception if a call is not found" do
      expect {
        described_class.new(id: 1, sid: "something").find
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
