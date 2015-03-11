require 'rails_helper'
require 'support/test_objects'

RSpec.describe "Stats API V1", type: :request do

  let(:request_headers) do
    user = User.create!(email: 'tester@tester.com', password: 'somepass', password_confirmation: 'somepass', authentication_token: 'api-token')
    
    return {'Accept' => 'application/json'},
    {'X-User-Email' => user.email},
    {'X-User-Token' => user.authentication_token}
  end
  
  describe 'GET /api/v1/stats' do
    it 'returns HTTP Status OK' do
      get '/api/v1/stats', {}, request_headers
    end

    it 'returns a list of existing stats' do
      stats = TestObjects.stats!(2)
      get '/api/v1/stats', {}, request_headers

      stats = stats.map {|s| s.attributes}
      stats.each {|s| s['_id'] = s['_id'].to_s}
      expect(response_body).to match_array(stats)
    end
  end

  def response_body
    JSON.parse(response.body)
  end

end