class Tagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tagger, polymorphic: true, optional: true

  after_commit :create_hashtag_stats

  def create_hashtag_stats
    count = Tagging.where(taggable_type: "Post").where(context: context).count
    hashtag_stat = HashtagStat.find_or_create_by(context: context)
    hashtag_stat.update_column(:count, count)
  end
end
