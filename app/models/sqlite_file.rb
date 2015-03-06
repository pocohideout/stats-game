class SqliteFile
  include Mongoid::Document
  
  validates :file, presence: { message: 'is required' }
  
  field :file, type: BSON::Binary
  
  def self.create_from!(stats)
    create_db_file(stats) do |file|
      return SqliteFile.create!(file: BSON::Binary.new(IO.read(file, mode: 'rb'), :generic))
    end
  end
  
  private
  
  def self.create_db_file(stats)
    begin
      dbfile = Tempfile.new('sqlite', Rails.root.join('tmp'))
      db = Sequel.connect("sqlite://#{dbfile.path}")
      
      create_stats_table(db)
      insert_stats(db, stats)

      yield(dbfile)
    ensure
      db.disconnect
      dbfile.unlink
    end
  end
  
  def self.create_stats_table(db)
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
  
  def self.insert_stats(db, stats)
    stats.each do |x|
      db[:stats].insert(
        category: x.category_cd,
        question: x.question,
        answer: x.answer,
        source: x.source,
        year: x.year,
        link: x.link
      )
    end
  end
end
