require 'rails_helper'
require 'support/test_objects'

describe "stats/index", type: :view do
  let(:stat_ref) { TestObjects.stat }

  it 'renders a list of stats' do
    assign :stats, Kaminari.paginate_array(TestObjects.stats!(2)).page(1)
    render
    assert_select "tr>td", :text => stat_ref.id.generation_time.strftime('%Y-%m-%d'), :count => 2
    assert_select "tr>td", :text => stat_ref.category.to_s.capitalize, :count => 2
    assert_select "tr>td", :text => stat_ref.answer, :count => 2
    assert_select "tr>td", :text => stat_ref.year.to_s, :count => 2
    assert_select "tr>td", :text => /#{Regexp.quote(stat_ref.question)}/, :count => 2
    assert_select "tr>td", :text => stat_ref.source, :count => 2
    assert_select "tr>td", :text => 'Click here', :count => 2
    assert_select "tr>td>a[href=?]", stat_ref.link, count: 2
  end
end