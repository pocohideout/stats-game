require 'rails_helper'

describe Api::V1::StatsController, type: :controller do

  describe 'GET #index' do
    it 'returns a paginated list of stats' do
      list = TestObjects.stats!(5)
      list = list.map {|s| s.attributes}
      list.each {|s| s['_id'] = s['_id'].to_s}
      
      # First page should have the latest 2 items
      get :index, {per_page: 2}
      expect(response_body).to eq(list[3..4].reverse)
      
      # Second page should have the next 2 items
      get :index, {per_page: 2, page: 2}
      expect(response_body).to eq(list[1..2].reverse)
      
      # Third page should have 1 remaining item
      get :index, {per_page: 2, page: 3}
      expect(response_body).to eq([list[0]])
      
      # Fourth page should have 0 items
      get :index, {per_page: 2, page: 4}
      expect(response_body).to eq([])
    end
  end

  def response_body
    JSON.parse(response.body)
  end

end