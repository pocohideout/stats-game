require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  let(:request_headers) { {'Accept' => 'application/json'} }
  let(:password) { 'somepass' }
  let(:user) { User.create!(email: 'tester@tester.com', password: password, password_confirmation: password) }

  describe 'POST /users/sign_in' do
    it "returns the user's api token if given valid credentials" do
      post '/users/sign_in', { user: {email: user.email, password: password} }, request_headers
      expect(response).to have_http_status :ok

      body = JSON.parse(response.body)
      user.reload
      expect(body['user']['token']).to eq(user.authentication_token)
    end

    it 'returns unauthorized user error if given invalid credentials' do
      post '/users/sign_in', { user: {email: user.email, password: 'blah'} }, request_headers
      expect(response).to have_http_status :unauthorized
    end
  end
  
  describe 'DELETE /users/sign_out' do
    it "invalidates the user's api token" do
      sign_in
      
      request_headers['X-User-Email'] = user.email
      request_headers['X-User-Token'] = user.authentication_token

      delete '/users/sign_out', nil, request_headers
      expect(response).to have_http_status :ok

      user.reload
      expect(user.authentication_token).to be_nil
    end
    
    it 'returns unauthorized user error if email header not provided' do
      sign_in
      
      request_headers['X-User-Token'] = 'test'
      
      delete '/users/sign_out', nil, request_headers
      expect(response).to have_http_status :unauthorized
    end
    
    it 'returns unauthorized user error if token header not provided' do
      sign_in
      
      request_headers['X-User-Email'] = 'test'
      
      delete '/users/sign_out', nil, request_headers
      expect(response).to have_http_status :unauthorized
    end
  end
  
end

def sign_in
  post '/users/sign_in', { user: {email: user.email, password: user.password} }, request_headers
  user.reload
end