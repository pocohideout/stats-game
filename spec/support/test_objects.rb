module TestObjects
  # Returns a valid Stat
  def self.stat
    Stat.new(
      category: :science,
      question: 'Some question over ___ characters long',
      answer: '20.0',
      source: 'UC Berkeley',
      year: 2015,
      link: 'http://www.somelink.com'
    )
  end
  
  def self.stats(count)
    list = []
    count.times do |i|
      list << Stat.new(
        category: :science,
        question: "Some question over ___ characters long #{i}",
        answer: '20.0',
        source: 'UC Berkeley',
        year: 2015,
        link: 'http://www.somelink.com'
      )
    end
    list
  end
end