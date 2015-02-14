require 'rails_helper'

RSpec.describe "stats/show", type: :view do
  before(:each) do
    @stat = assign(:stat, Stat.create!(
      :category => 1,
      :answer => "9.99",
      :year => 2,
      :question => "MyText",
      :source => "Source",
      :link => "MyText2"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/MyText2/)
  end
end
