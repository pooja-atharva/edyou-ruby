module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_on(filtering_params)
      filtering_params['page'] = 1 if filtering_params['page'].blank? || filtering_params['page'].to_i < 1
      filtering_params['per'] = Kaminari.config.default_per_page if filtering_params['per'].blank?
      results = where(nil)
      filtering_params.each do |key, value|
        key = 'per' if key == 'page_limit'
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
