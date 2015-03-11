require 'ext/array'

class StatSearchEngine
  def similar(question, limit: 10)
    words = question.downcase.gsub(/[\?!,.\(\)":;]/i, '')
    words = words.split(/\s+/).uniq.keywords
    remove_invalid_search_terms!(words)
    
    search_str = ''
    words.each do |w|
      search_str += "\"#{w}\" "
    end

    SearchEngine.search(Stat, search_str, limit: limit)
  end
  
  private
  
  def remove_invalid_search_terms!(words)
    remove_words_with_underscore!(words)
    remove_words_with_numbers!(words)
  end
  
  def remove_words_with_underscore!(words)
    words.reject! {|x| x.include? '_' }
  end
  
  def remove_words_with_numbers!(words)
    words.reject! {|x| x =~ /\d/}
  end
end