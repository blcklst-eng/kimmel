class AssetHelper
  def self.url(asset_path)
    ActionController::Base.helpers.asset_url(asset_path, skip_pipeline: true)
  end
end
