require "rails_helper"

RSpec.describe CallTransition, type: :model do
  describe ".in_progress" do
    it "returns all transitions that are in_progress" do
      in_progress_transition = create(:call_transition, to_state: "in_progress")
      completed_transition = create(:call_transition, to_state: "completed")

      result = described_class.in_progress

      expect(result).to include(in_progress_transition)
      expect(result).not_to include(completed_transition)
    end
  end
end
