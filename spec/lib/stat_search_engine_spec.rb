require 'stat_search_engine'

describe StatSearchEngine do

  context 'when searching for similar questions' do
    it 'ignores words with underscore' do
      question = 'Question with ___% underscore'
      expected_query = '"question" "underscore" '
      
      verify_search(question, expected_query)
    end
    
    it 'ignores words with numbers' do
      question = 'Question with 34f numbers'
      expected_query = '"question" "numbers" '

      verify_search(question, expected_query)
    end
    
    it 'removes common punctuation' do
      question = 'Question? with punctuation, donu\'t word. (horse) some-word "taxi" whoa! sister: bro;'
      expected_query = '"question" "punctuation" "donu\'t" "word" "horse" "some-word" "taxi" "whoa" "sister" "bro" '

      verify_search(question, expected_query)
    end
    
    def verify_search(question, expected_query)
      stub_const('Stat', 1)
      search_engine = class_double('SearchEngine').as_stubbed_const
      expect(search_engine).to receive(:search).with(Stat, expected_query, limit: 10)
      
      StatSearchEngine.new.similar(question)
    end
  end

end