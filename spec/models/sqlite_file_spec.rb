require 'rails_helper'
require 'support/test_objects'

RSpec.describe SqliteFile, type: :model do
  it 'is valid with a file' do
    sqlite_file = SqliteFile.new(file: BSON::Binary.new('test', :generic))
    expect(sqlite_file).to be_valid
  end

  it 'is invalid without a file' do
    sqlite_file = SqliteFile.new
    sqlite_file.valid?
    expect(sqlite_file.errors[:file]).to include('is required')
  end
end
