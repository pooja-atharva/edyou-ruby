require 'faker'
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    users = []
    30..(rand(50)).times do
      begin
        user = User.create!(
          email:                          Faker::Internet.email(domain: 'edu.com'),
          password:                       Faker::Internet.password(min_length: 8),
          name:                           Faker::Name.unique.name
          )
      rescue
        next
      end

      users << user

      puts "User #{user.name} creating profile..."

      Profile.create!(
        user:                           user,
        class_name:                     Faker::Date.between(from: 5.years.ago, to: Date.today).strftime("%Y"),
        graduation:                     "Undergraduate",
        major:                          "Computer Science",
        status:                         "Single",
        attending_university:           Faker::University.name,
        high_school:                    Faker::University.name,
        from_location:                  Faker::Address.city,
        country:                        Faker::Address.country,
        gender:                         Faker::Gender.binary_type,
        religion:                       "Christian",
        language:                       "English, Spanish, French",
        date_of_birth:                  Faker::Date.between(from: 16.years.ago, to: 21.years.ago),
        favourite_quotes:               Faker::Quote.famous_last_words
        )

      puts "User #{user.name} creating albums..."
      public_permission = Permission.album_permissions.find_by(permission_type_id: 1)

      1..(rand(5)).times do
        album = Album.create!(
          name:                         Faker::FunnyName.name,
          description:                  Faker::Lorem.paragraph,
          user:                         user,
          permission_id:                public_permission.id
          )
      end

      puts "User #{user.name} creating groups"

      1..(rand(3)).times do

        group = Group.create!(
          name:                         Faker::FunnyName.name,
          description:                  Faker::Lorem.paragraph,
          owner:                        user
          )
        puts "Group #{group.name} created... for #{user.name}..."
      end
    end

    total_users = users.size

    users.each do |user|
      1..(rand(5)).times do
        begin
          puts "User #{user.name} creating friends..."
          rand_no = rand(total_users)
          user.friendships.create!(friend_id: users[rand_no].id, status: [0, 1].sample, invite_sent: Time.now)
        rescue
          puts "User #{user.name} sending friend request again..."
          next
        end
      end
    end
  end
end
