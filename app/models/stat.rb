class Stat
  include Mongoid::Document
  include SimpleEnum::Mongoid

  validates_presence_of :category, :answer, :question

  as_enum :category, science: 0, society: 1, entertainment: 2
  field :answer, type: String
  field :question, type: String
  field :source, type: String
  field :year, type: Integer
  field :link, type: String
end
