require "rails_helper"

RSpec.describe MessageMediaImageVariant, :active_storage do
  describe "#width" do
    it "returns the provided width when the variant can be resized" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 50, height: 50)

      expect(variant.width).to eq(50)
    end

    it "returns the proportional width when the provided width cannot be achieved exactly" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 50, height: 75)

      expect(variant.width).to eq(75)
    end

    it "returns the original width if the provided width is greater than the original" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 150, height: 50)

      expect(variant.width).to eq(128)
    end

    it "returns the original width if the provided height is greater than the original" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 50, height: 150)

      expect(variant.width).to eq(128)
    end
  end

  describe "#height" do
    it "returns the provided height when the variant can be resized" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 50, height: 50)

      expect(variant.height).to eq(50)
    end

    it "returns the proportional height when the provided height cannot be achieved exactly" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 75, height: 50)

      expect(variant.height).to eq(75)
    end

    it "returns the original height if the provided height is greater than the original" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 50, height: 150)

      expect(variant.height).to eq(128)
    end

    it "returns the original height if the provided width is greater than the original" do
      media = create_analyzed_file_blob

      variant = described_class.new(media: media, width: 150, height: 50)

      expect(variant.height).to eq(128)
    end
  end

  describe "#url" do
    it "returns the url of the variant" do
      media = create_file_blob

      variant = described_class.new(media: media, width: 50, height: 50)

      expect(variant.url).to include(Rails.configuration.api_host)
      expect(variant.url).to include(media.filename.to_s)
    end
  end
end
