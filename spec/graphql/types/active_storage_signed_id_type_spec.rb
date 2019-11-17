require "rails_helper"

describe Types::ActiveStorageSignedIdType, :active_storage do
  describe ".coerce_input" do
    it "returns the value when the signed id is valid" do
      blob = create_blob
      result = described_class.coerce_input(blob.signed_id, {})

      expect(result).to eq(blob.signed_id)
    end

    it "raises and error when the signed id is not valid" do
      expect {
        described_class.coerce_input("abcd", {})
      }.to raise_error(GraphQL::CoercionError)
    end
  end
end
