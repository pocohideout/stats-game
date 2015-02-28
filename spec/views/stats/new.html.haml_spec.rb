require 'rails_helper'

RSpec.describe "stats/new", type: :view do
  before(:each) do
    assign(:stat, Stat.new(  #TODO Why do we need this assign? Looks like it is not used
      :category => 1,
      :answer => "9.99",
      :year => 1,
      :question => "MyText with more than 20 chars",
      :source => "MyString",
      :link => "MyText"
    ))
  end

  it "renders new stat form" do
    render

    assert_select "form[action=?][method=?]", stats_path, "post" do

      assert_select "select#stat_category[name=?]", "stat[category]"

      assert_select "input#stat_answer[name=?]", "stat[answer]"

      assert_select "input#stat_year[name=?]", "stat[year]"

      assert_select "textarea#stat_question[name=?]", "stat[question]"

      assert_select "input#stat_source[name=?]", "stat[source]"

      assert_select "textarea#stat_link[name=?]", "stat[link]"
    end
  end
end
