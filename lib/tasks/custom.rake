require 'amazing_stats_api'
require 'stat_exporter'

namespace :custom do
  desc "Export stats from the web app into a sqlite file"
  task :export_stats, [:site, :email, :password] => :environment do |t, args|
    if !args.site
      puts 'ERROR: "site" argument is required (e.g. rake custom:export_stats[www.site.com])'
    end
    
    api = AmazingStatsAPI.new(args.site, args.email, args.password)
    file = StatExporter.new(api).export
    
    puts "Exported stats to #{file.path}"
  end
end