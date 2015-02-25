module TestObjects
  # Return a valid Stat
  def self.stat
    Stat.new(attributes)
  end

  # Create and return a list of Stats
  def self.stats!(count)
    list = []
    count.times do |i|
      attr = attributes
      attr[:question] += " #{i}"
      list << Stat.create!(attr)
    end
    list
  end
  
  private
  
  def self.attributes
    {
      category: :science,
      question: 'Some question over ___ characters long',
      answer: 20.0,
      source: 'UC Berkeley',
      year: 2015,
      link: 'http://www.somelink.com'
    }
  end
end