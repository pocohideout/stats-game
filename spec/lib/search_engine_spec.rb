require 'search_engine'

describe SearchEngine do
  it 'returns a list of search results from DB search engine' do
    model = double('A Rails model')
    search_term = 'some search terms'
    
    objects = [1, 2]
    allow(model).to receive_message_chain('limit.text_search').and_return(objects)
    expect(model.limit).to receive(:text_search).with(search_term)
    
    results = SearchEngine.search(model, search_term)
    
    expect(results).to eq objects
  end
  
  it 'limits search results by 50' do
    model = double('A Rails model')

    objects = [1, 2]
    allow(model).to receive_message_chain('limit.text_search').and_return(objects)
    
    expect(model).to receive(:limit).with(50)
    
    SearchEngine.search(model, 'something')
  end
end