class SearchEngine
  def self.search(model, search_term)
    SearchEngine.new(model).search(search_term)
  end
  
  def initialize(model)
    @model = model
  end
  
  def search(search_term, limit: 50)
    results = []
    search = @model.limit(limit).text_search(search_term)
    search.each do |obj|
      results << obj
    end
    results
  end
end