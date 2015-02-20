require "#{Rails.root}/spec/support/test_objects"

namespace :db do
  desc "Populate DB with test data"
  task populate: :environment do
    count = 55
    TestObjects.stats!(count)
    puts "Inserted #{count} stats"
  end

end
