module Pagination
  extend ActiveSupport::Concern

  def page_meta(object, meta = {})
    if object.respond_to?(:current_page)
      per_page = 5 if per_page.to_i == 0
      meta[:pagination] = {
        per_page: per_page.to_i,
        current_page: object.current_page,
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
      }
    end
    meta
  end
end
