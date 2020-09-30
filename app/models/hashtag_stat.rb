class HashtagStat < ApplicationRecord
  include Filterable

  def self.search(query)
    where("context LIKE ?",  "#{query}%")
  end
end
