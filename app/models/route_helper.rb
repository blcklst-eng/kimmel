class RouteHelper
  include Singleton
  include Rails.application.routes.url_helpers

  class << self
    delegate_missing_to :instance
  end
end
