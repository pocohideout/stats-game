require 'rails_helper'
require 'support/test_objects'

feature 'Stat Search', :type => :feature do
  include Warden::Test::Helpers
  
  before(:each) do
    Warden.test_mode!
    
    user = User.create!(email: 'test@test.com', password: 'somepass', password_confirmation: 'somepass')
    login_as(user, scope: :user)
  end
  
  after(:each) do
    Warden.test_reset!
  end
  
  scenario 'User runs a search' do
    TestObjects.stats!(2)
    stat = TestObjects.stat
    stat.question = 'Test line test line test line'
    stat.save!
    
    visit stats_url

    fill_in 'searchterm', with: 'question characters'
    click_button 'searchbutton'

    expect(page.all('table tbody tr').count).to eq 2
  end
end