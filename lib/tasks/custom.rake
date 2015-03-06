require "stat_exporter"

namespace :custom do
  desc "Export stats from the web app into a sqlite file"
  task :export_stats, [:site] => :environment do |t, args|
    if !args.site
      puts 'ERROR: "site" argument is required (e.g. rake custom:export_stats[www.site.com])'
    end
    StatExporter.new(args.site).export
  end
end