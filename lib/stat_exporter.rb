require 'rest_client'

class StatExporter
  def initialize(site)
    @site = site
  end
  
  def export
    RestClient.get "#{site}/stats.json"
    #TODO Implement
  end
end