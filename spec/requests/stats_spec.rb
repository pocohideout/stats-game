require 'rails_helper'

RSpec.describe "Stats", type: :request do
  describe "GET /stats" do
    it "works! (now write some real specs)" do
      login
      get '/stats'
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /stats/similar' do
    it 'returns similar questions' do
      login
      
      stats = TestObjects.stats!(2)
      stat = TestObjects.stat
      stat.question = 'blah blah blu blu blah blah'
      stat.save!
      
      get '/stats/similar', {question: 'a question of ___ characters'}, {'Accept' => 'application/json'}
      expect(response).to have_http_status 200
      
      stats_questions = stats.map {|x| x.question }
      body = JSON.parse(response.body)
      expect(body['list']).to match_array(stats_questions)
    end
  end
end

def login
  user = User.create!(email: 'tester@tester.com', password: 'somepass', password_confirmation: 'somepass')
  post new_user_session_path, 'user[email]': 'tester@tester.com', 'user[password]': 'somepass'
end