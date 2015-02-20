require 'rails_helper'

RSpec.describe "stats/show", type: :view do
  before(:each) do
    @stat = assign(:stat, Stat.create!(
      :category => 1,
      :answer => "9.99",
      :year => 2015,
      :question => "MyText with more than 20 chars",
      :source => "Source",
      :link => "http://www.mylink.com"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2015/)
    expect(rendered).to match(/MyText with more than 20 chars/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/http:\/\/www.mylink.com/)
  end
end
