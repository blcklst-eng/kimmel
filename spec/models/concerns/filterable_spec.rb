require "rails_helper"

RSpec.describe "Filtering model", type: :model do
  User.class_eval do
    include Filterable

    scope :walter_id, ->(walter_id) {
      where(walter_id: walter_id)
    }
  end

  describe ".filter_by" do
    it "filters by a scope" do
      record = create(:user, walter_id: 2)
      another_record = create(:user, walter_id: 3)

      filtered = User.filter_by(walter_id: 2)

      expect(filtered).to include(record)
      expect(filtered).not_to include(another_record)
    end
  end
end
