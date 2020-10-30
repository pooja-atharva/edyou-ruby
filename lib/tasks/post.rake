namespace :post do
  desc "Delete temp post in last 24 hours"
  task :deactivate => :environment do
    Post.daily_temp_post.destroy_all
  end
end
