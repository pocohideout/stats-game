module TestObjects
  # Returns a valid Stat
  def self.stat
    Stat.new(
      category: :science,
      question: 'Some question over ___ characters long',
      answer: 20.0,
      source: 'UC Berkeley',
      year: 2015,
      link: 'http://www.somelink.com'
    )
  end
end