require 'rails_helper'
require 'support/test_objects'

describe "stats/index", type: :view do
  let(:stat_ref) { TestObjects.stat }

  it 'renders a list of stats' do
    create_stats(2)
    render
    assert_select "tr>td", :text => stat_ref.category.to_s, :count => 2
    assert_select "tr>td", :text => stat_ref.answer, :count => 2
    assert_select "tr>td", :text => stat_ref.year.to_s, :count => 2
    assert_select "tr>td", :text => /#{Regexp.quote(stat_ref.question)}/, :count => 2
    assert_select "tr>td", :text => stat_ref.source, :count => 2
    assert_select "tr>td", :text => stat_ref.link, :count => 2
  end
end

def create_stats(count)
  list = TestObjects.stats(count)
  list.each { |x| x.save! }
  assign(:stats, list)
end