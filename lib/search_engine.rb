class SearchEngine
  def self.search(model, search_term)
    results = []
    search = model.limit(50).text_search(search_term)
    search.each do |obj|
      results << obj
    end
    results
  end
end