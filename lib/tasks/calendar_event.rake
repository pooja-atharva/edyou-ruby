namespace :calendar_event do
  desc "Active/completed Calendar Event in 24 hours"
  task :update_status => :environment do
    CalendarEvent.active.passed_event.update_all(status: 'completed')
  end
end
