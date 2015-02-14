require 'rails_helper'

RSpec.describe "stats/index", type: :view do
  before(:each) do
    assign(:stats, [
      Stat.create!(
        :category => "science",
        :answer => "9.99",
        :year => 2,
        :question => "MyText",
        :source => "Source",
        :link => "MyText2"
      ),
      Stat.create!(
        :category => "science",
        :answer => "9.99",
        :year => 2,
        :question => "MyText",
        :source => "Source",
        :link => "MyText2"
      )
    ])
  end

  it "renders a list of stats" do
    render
    assert_select "tr>td", :text => "science".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Source".to_s, :count => 2
    assert_select "tr>td", :text => "MyText2".to_s, :count => 2
  end
end
