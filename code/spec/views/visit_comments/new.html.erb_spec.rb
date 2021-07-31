require 'rails_helper'

RSpec.describe "visit_comments/new", type: :view do
  before(:each) do
    assign(:visit_comment, VisitComment.new(
      appartment: nil,
      contact: "MyString",
      address: "MyString",
      extra_comments: "MyString",
      elevator_status: 1,
      balcony: 1,
      view: 1,
      water_key_status: 1,
      water_pressure: 1
    ))
  end

  it "renders new visit_comment form" do
    render

    assert_select "form[action=?][method=?]", visit_comments_path, "post" do

      assert_select "input[name=?]", "visit_comment[appartment_id]"

      assert_select "input[name=?]", "visit_comment[contact]"

      assert_select "input[name=?]", "visit_comment[address]"

      assert_select "input[name=?]", "visit_comment[extra_comments]"

      assert_select "input[name=?]", "visit_comment[elevator_status]"

      assert_select "input[name=?]", "visit_comment[balcony]"

      assert_select "input[name=?]", "visit_comment[view]"

      assert_select "input[name=?]", "visit_comment[water_key_status]"

      assert_select "input[name=?]", "visit_comment[water_pressure]"
    end
  end
end
