class AddHighPriorityToHashtagStat < ActiveRecord::Migration[6.0]
  def change
    add_column :hashtag_stats, :high_priority, :boolean, default: false
  end
end
