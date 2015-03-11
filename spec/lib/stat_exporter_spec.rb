require 'stat_exporter'
require 'sequel'
require 'date'

describe StatExporter do
  
  let(:dbfile) { Tempfile.new('test-sqlite') }
  
  it 'downloads the list of stats and exports it to a sqlite file' do
    list = stats(1)
    
    api = instance_double('AmazingStatsAPI')
    expect(api).to receive(:stats).with(per_page: 50, page: 1).and_return(list)
    expect(api).to receive(:stats).with(per_page: 50, page: 2).and_return([])
    
    file = StatExporter.new(api).export(dbfile)
    expect(file.path).to eq(dbfile.path)

    begin
      db = Sequel.connect("sqlite://#{dbfile.path}")
      sqlite_stats = db[:stats].all
    
      compare_stats(sqlite_stats, list)
    ensure
      db.disconnect
    end
  end
  
  it 'downloads all stats and exports the list to a sqlite file' do
    list = stats(5)
    list1 = list[3..4].reverse
    list2 = list[1..2].reverse
    list3 = [list[0]]
    
    api = instance_double('AmazingStatsAPI')
    chunk = 2
    stub_const('StatExporter::CHUNK', chunk)
    expect(api).to receive(:stats).with(per_page: chunk, page: 1).and_return(list1)
    expect(api).to receive(:stats).with(per_page: chunk, page: 2).and_return(list2)
    expect(api).to receive(:stats).with(per_page: chunk, page: 3).and_return(list3)
    expect(api).to receive(:stats).with(per_page: chunk, page: 4).and_return([])
    
    file = StatExporter.new(api).export(dbfile)
    expect(file.path).to eq(dbfile.path)
    
    begin
      db = Sequel.connect("sqlite://#{dbfile.path}")
      sqlite_stats = db[:stats].order(Sequel.desc(:id))

      compare_stats(sqlite_stats, list)
    ensure
      db.disconnect
    end
  end
  
  it 'replaces any existing sqlite stats file' do
    create_sqlite
    
    list = stats(1)
    api = instance_double('AmazingStatsAPI')
    expect(api).to receive(:stats).with(per_page: 50, page: 1).and_return(list)
    expect(api).to receive(:stats).with(per_page: 50, page: 2).and_return([])
    
    StatExporter.new(api).export(dbfile)
    
    begin
      db = Sequel.connect("sqlite://#{dbfile.path}")
      expect(db[:stats].count).to eq 1
    ensure
      db.disconnect
    end
  end
  
  it 'includes the date in the default sqlite filename' do
    api = instance_double('AmazingStatsAPI')
    expect(api).to receive(:stats).with(per_page: 50, page: 1).and_return([])
    
    begin
      file = StatExporter.new(api).export
      expect(file.path).to eq("/tmp/stats-#{Date.today.strftime('%Y%m%d')}.sqlite")
    ensure
      File.delete(file)
    end
  end
  
  def stats(count)
    stats = []
    count.times do |i|
      stats << {"_id"=>"54e7c642776174cd8d21000#{i}", "category_cd"=>0, "question"=>"Some question over ___ characters long #{i}", "answer"=>20.0, "source"=>"UC Berkeley", "year"=>2015, "link"=>"http://www.somelink.com"}
    end
    stats
  end
  
  def compare_stats(sqlite, expected)
    expect(sqlite.count).to eq(expected.count)
    sqlite.each_with_index do |x, i|
      expect(x[:category]).to eq(expected[i]['category_cd'])
      expect(x[:question]).to eq(expected[i]['question'])
      expect(x[:answer]).to eq(expected[i]['answer'])
      expect(x[:source]).to eq(expected[i]['source'])
      expect(x[:year]).to eq(expected[i]['year'])
      expect(x[:link]).to eq(expected[i]['link'])
    end
  end
  
  def create_sqlite
    begin
      db = Sequel.connect("sqlite://#{dbfile.path}")
      
      create_stats_table(db)
      insert_stat(db)
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
  
  def insert_stat(db)
    db[:stats].insert(
      category: 0,
      question: 'Some question over ___ characters long',
      answer: 20.0,
      source: 'UC Berkeley',
      year: 2015,
      link: 'www.somelink.com'
    )
  end

end