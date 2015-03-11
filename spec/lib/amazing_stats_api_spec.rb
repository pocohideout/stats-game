require 'amazing_stats_api'
require 'rest_client'

describe AmazingStatsAPI do
  
  let(:stat) do
    {category: :science, answer: 2.6, year: 2014, question: "___% of the world's total energy consumption comes from nuclear power.", source: "REN21", link: "http://www.ren21.net/Portals/0/documents/Resources/GSR/2014/GSR2014_KeyFindings_low%20res.pdf"}
  end
  
  let(:login_response) do
    token = {user: {token: 'sometoken'}}
    
    response = double('A response')
    expect(response).to receive(:body).and_return(token.to_json)

    response
  end
  
  let(:get_response) do
    response = double('A response')
    expect(response).to receive(:body).at_least(:once).and_return(stat.to_json)
    
    response
  end
  
  it 'returns a list of stats from the site' do
    api = AmazingStatsAPI.new('www.testsite', 'email', 'password')

    rest_client = class_double('RestClient').as_stubbed_const
    expect(rest_client).to receive(:post).and_return(login_response)
    expect(rest_client).to receive(:get).and_return(get_response)

    expect(api.stats).to eq(JSON.parse(stat.to_json))
  end
  
  it 'only calls sign_in if it does not yet have the api token' do
    api = AmazingStatsAPI.new('www.testsite', 'email', 'password')
    
    rest_client = class_double('RestClient').as_stubbed_const
    expect(rest_client).to receive(:post).once.and_return(login_response)
    expect(rest_client).to receive(:get).exactly(2).times.and_return(get_response)
    
    api.stats
    api.stats
  end

end