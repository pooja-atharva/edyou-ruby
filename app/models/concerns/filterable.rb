module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_on(filtering_params)
      results = where(nil)
      filtering_params.each do |key, value|
        key = "per" if key == "page_limit"
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
