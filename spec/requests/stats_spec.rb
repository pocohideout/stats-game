require 'rails_helper'

RSpec.describe "Stats", type: :request do
  describe "GET /stats" do
    it "works! (now write some real specs)" do
      login
      get '/stats'
      expect(response).to have_http_status(200)
    end
  end
end

def login
  user = User.create!(email: 'tester@tester.com', password: 'somepass', password_confirmation: 'somepass')
  post new_user_session_path, 'user[email]': 'tester@tester.com', 'user[password]': 'somepass'
end