require 'rails_helper'

RSpec.describe "stats/edit", type: :view do
  before(:each) do
    @stat = assign(:stat, Stat.create!(
      :category => "society",
      :answer => "9.99",
      :year => 2014,
      :question => "MyText",
      :source => "MyString",
      :link => "MyText2"
    ))
  end

  it "renders the edit stat form" do
    render

    assert_select "form[action=?][method=?]", stat_path(@stat), "post" do

      assert_select "select#stat_category[name=?]", "stat[category]"
      assert_select "option[selected=?][value=?]", "selected", "society"

      assert_select "input#stat_answer[name=?][value=?]", "stat[answer]", "9.99"

      assert_select "input#stat_year[name=?][value=?]", "stat[year]", "2014"

      assert_select "textarea#stat_question[name=?]", "stat[question]", text: "MyText"

      assert_select "input#stat_source[name=?][value=?]", "stat[source]", "MyString"

      assert_select "textarea#stat_link[name=?]", "stat[link]", text: "MyText2"
    end
  end
end
