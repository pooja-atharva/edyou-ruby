require 'faker'
namespace :db do
  desc "Fill database with sample data"
  task dummy_post: :environment do
    users = User.all
    users.each do |user|
      user.friends.each do |friend|
        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            offset = rand(Model.count)
            rand_record = Feeling.offset(offset).first
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, feeling_id: rand_record.id)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            offset = rand(Model.count)
            rand_record = Activity.offset(offset).first
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, activity_id: rand_record.id)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, permission_id: 1)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, permission_id: 2)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, permission_id: 3, access_requirement_ids: [user.id])
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, permission_id: 4, access_requirement_ids: [user.id])
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, permission_id: 5)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, permission_id: 6)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            Post.create(user_id: friend.id, body: Faker::Lorem.paragraph, delete_post_after_24_hour: true)
          rescue
            next
          end
        end

        1..(rand(10)).times do
          begin
            post = Post.create(user_id: friend.id, body: Faker::Lorem.paragraph)
            post.taggings.create(tagger_type: 'User', tagger_id: user.id)
          rescue
            next
          end
        end

      end
    end
  end
end
