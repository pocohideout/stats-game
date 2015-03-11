require 'rest_client'
require 'date'

class StatExporter

  CHUNK = 50

  def initialize(api)
    @api = api
  end
  
  def export(file = "/tmp/stats-#{Date.today.strftime('%Y%m%d')}.sqlite")
    dbfile = File.new(file, 'wb')
    create_db_file(dbfile)
    dbfile
  end
  
  private
  
  def create_db_file(dbfile)
    begin
      db = Sequel.connect("sqlite://#{dbfile.path}")
      
      create_stats_table(db)
      insert_stats(db)
    ensure
      db.disconnect
    end
  end
  
  def create_stats_table(db)
    db.create_table :stats do
      primary_key :id
      Integer :category
      String :question
      Float :answer
      String :source
      Integer :year
      String :link
    end
  end
  
  def insert_stats(db)
    n = 0
    while 1 do
      n += 1
      stats = @api.stats(per_page: CHUNK, page: n)
      
      break if stats.empty?
      
      stats.each do |x|
        db[:stats].insert(
          category: x['category_cd'],
          question: x['question'],
          answer: x['answer'],
          source: x['source'],
          year: x['year'],
          link: x['link']
        )
      end
    end
  end

end