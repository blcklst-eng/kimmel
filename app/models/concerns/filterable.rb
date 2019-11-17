module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(filtering_params)
      return self unless filtering_params

      results = where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value)
      end
      results
    end
  end
end
