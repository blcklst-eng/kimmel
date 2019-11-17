require "rails_helper"

RSpec.describe "Ordering model", type: :model do
  class User < ApplicationRecord
    include Orderable

    scope :order_by_email, ->(direction) {
      order(email: direction)
    }
  end

  describe ".order_by" do
    it "orders by a scope" do
      second_record = create(:user, email: "second@email.com")
      first_record = create(:user, email: "first@email.com")

      ordered = User.order_by(:email, :asc)

      expect(ordered.first).to eq(first_record)
      expect(ordered.second).to eq(second_record)
    end

    it "falls through to a column if the scope does not exist" do
      second_record = create(:user, first_name: "second")
      first_record = create(:user, first_name: "first")

      ordered = User.order_by(:first_name, :asc)

      expect(ordered.first).to eq(first_record)
      expect(ordered.second).to eq(second_record)
    end
  end
end
