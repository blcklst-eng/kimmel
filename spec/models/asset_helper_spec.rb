require "rails_helper"

RSpec.describe AssetHelper do
  describe ".url" do
    it "returns the path to the asset" do
      result = AssetHelper.url("audio/ringback.wav")

      expect(result).to eq("#{host}/audio/ringback.wav")
    end
  end

  def host
    Rails.application.config.action_controller.asset_host
  end
end
