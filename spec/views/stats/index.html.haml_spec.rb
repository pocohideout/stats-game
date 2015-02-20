require 'rails_helper'

RSpec.describe "stats/index", type: :view do
  before(:each) do
    assign(:stats, [
      Stat.create!(
        :category => "science",
        :answer => "9.99",
        :year => 2015,
        :question => "MyText with more than 20 chars",
        :source => "Source",
        :link => "http://www.mylink.com"
      ),
      Stat.create!(
        :category => "science",
        :answer => "9.99",
        :year => 2015,
        :question => "MyText with more than 20 chars",
        :source => "Source",
        :link => "http://www.mylink.com"
      )
    ])
  end

  it "renders a list of stats" do
    render
    assert_select "tr>td", :text => "science".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 2015.to_s, :count => 2
    assert_select "tr>td", :text => "MyText with more than 20 chars".to_s, :count => 2
    assert_select "tr>td", :text => "Source".to_s, :count => 2
    assert_select "tr>td", :text => "http://www.mylink.com".to_s, :count => 2
  end
end
