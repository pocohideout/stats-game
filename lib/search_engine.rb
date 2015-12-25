class SearchEngine
  def self.search(model, search_term, limit: 50)
    results = []
    #search = model.limit(limit).text_search(search_term)
    search = model.limit(limit).where( { :$text => {:$search => search_term} } )
    search.each do |obj|
      results << obj
    end
    results
  end
end