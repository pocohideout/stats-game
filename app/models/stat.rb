class Stat
  include Mongoid::Document
  include SimpleEnum::Mongoid

  validates :category, :question, :answer, presence: { message: 'is required' }
  validates :question, length: { minimum: 20, maximum: 180, too_short: 'is too short', too_long: 'is too long' }
  validates :answer,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999999, message: 'must be a number between 0 and 9,999,999' }
  validates :source, length: { maximum: 100, message: 'is too long' }
  validates :year,
    numericality: { message: 'is not a number' },
    inclusion: { in: 1500..Date.today.year, message: "must be a year between 1500 and #{Date.today.year}" }
  validates :link,
    length: { maximum: 300, message: 'is too long' },
    format: { with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/ix, message: 'is not a valid URL' }

  as_enum :category, science: 0, society: 1, entertainment: 2
  field :answer, type: String
  field :question, type: String
  field :source, type: String
  field :year, type: Integer
  field :link, type: String
  
  def answer=(val)
    write_attribute(:answer, val.to_f.round(1))
  end
end
