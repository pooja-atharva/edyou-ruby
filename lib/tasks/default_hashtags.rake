namespace :default_hashtags do
  desc 'Create default hashtags'
  task :create_hashtags => :environment do
    puts 'Start creating default hashtags...'
    create_hashtags = [ 'education', 'learning', 'school', 'love', 'motivation', 'students', 'study', 'covid', 'student', 'children', 'kids', 'teacher', 'college', 'india', 'knowledge', 'science', 'learn', 'university', 'success', 'business', 'teaching', 'bhfyp', 'community', 'inspiration', 'art', 'instagood', 'english', 'teachers', 'training', 'colleage', 'china', 'colleagegirls', 'chennai', 'followforlikeback', 'colleageart', 'likeforlikebacks', 'likeforlikeback', 'likeforlikes', 'likeforlike', 'followforlikesback', 'followforlikes', 'followforlike', 'colleagevibes', 'colleagewear', 'colleagelife', 'colleagedropout', 'schoolgirl', 'schoolfights', 'schoolmemes', 'colleageboy', 'schoolsupplies', 'schoollunch', 'schooluniform', 'schoolmemories', 'colleages', 'colleageoftheday', 'toronto', 'photography', 'teachersofinstagram', 'family', 'highschool', 'studygram', 'coronavirus', 'sekolah', 'kindergarten', 'class', 'happy', 'studentlife', 'corona', 'scuola', 'schooldays', 'music', 'photooftheday', 'classroom', 'teacherlife', 'stayhome', 'quarantine', 'parents', 'funnymemes', 'fashion' ]
    create_hashtags.each do |context|
      hashtag = Tagging.find_or_create_by(context: context)
      if hashtag.save
        hashtag_stat = HashtagStat.find_or_create_by(context: hashtag.context)
        hashtag_stat.update_column(:high_priority, true)
        puts "\n-----#{hashtag_stat.inspect}-----"
      end
    end
    puts '\nDone!!!'
    puts "Hashtags created count: #{create_hashtags.size}"
  end
end
