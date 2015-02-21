require 'rails_helper'
require 'support/test_objects'

describe Stat, type: :model do
  let(:stat) { TestObjects.stat }

  it 'is valid with a category, question, answer, source, year and link' do
    expect(stat).to be_valid
  end

  it 'is invalid without a category' do
    stat.category = nil
    stat.valid?
    expect(stat.errors[:category]).to include('is required')
  end

  it 'is invalid without a question' do
    expect_field :question, with_value: nil, to_have_error: 'is required'
  end

  it 'is invalid if the question is too short' do
    expect_field :question, with_value: 'Short', to_have_error: 'is too short'
  end

  it 'is invalid if the question is too long' do
    question_str = 'This is a question that is way too long, please shorten it please. This question is 181 characters long. This question is long. This question is long. This question is long. This qu'
    expect_field :question, with_value: question_str, to_have_error: 'is too long'
  end

  it 'is invalid without an answer' do
    expect_field :answer, with_value: nil, to_have_error: 'is required'
  end

  it 'is invalid if the answer is not a number' do
    expect_field :answer, with_value: 'h', to_have_error: 'must be a number between 0 and 9,999,999'
  end

  it 'is invalid if the answer is not within range' do
    expect_field :answer, with_value: -1, to_have_error: 'must be a number between 0 and 9,999,999'
    expect_field :answer, with_value: 10000000, to_have_error: 'must be a number between 0 and 9,999,999'
  end

  it 'is invalid if the source is too long' do
    source_str = 'This text is 101 characters long. This text is long. This text is too long. This text is too long. Th'
    expect_field :source, with_value: source_str, to_have_error: 'is too long'
  end

  it 'is invalid if the year is not in the correct format' do
    expect_field :year, with_value: 'h', to_have_error: 'is not a number'
  end

  it 'is invalid if the year is not within range' do
    current_year = Date.today.year
    expect_field :year, with_value: '1499', to_have_error: "must be a year between 1500 and #{current_year}"
    expect_field :year, with_value: current_year+1, to_have_error: "must be a year between 1500 and #{current_year}"
  end

  it 'is invalid if the link is not a URL' do
    expect_field :link, with_value: 'h', to_have_error: 'is not a valid URL'
  end

  it 'is invalid if the link is too long' do
    link_str = 'http://www.this-link-is-301-characters-long.com/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-too-long/this-link-is-way-to'
    expect_field :link, with_value: link_str, to_have_error: 'is too long'
  end

  it 'rounds answer to nearest 0.1' do
    stat.answer = '10.4612'
    expect(stat.answer).to eq '10.5'
  end
end

def expect_field(field, with_value:, to_have_error:)
  stat[field] = with_value
  stat.valid?
  expect(stat.errors[field]).to include(to_have_error)
end