class StatSearchEngine
  def similar(question, limit: 10)
    words = question.split(/\s+/).uniq.keywords
    words = remove_invalid_search_terms(words)
    
    search_str = ''
    words.each do |w|
      search_str += "\"#{w}\" "
    end

    SearchEngine.new(Stat).search(search_str, limit: limit)
  end
  
  private
  
  def remove_invalid_search_terms(words)
    words.reject {|x| x.include? '_' }
  end
end