require 'rails_helper'

RSpec.describe "visit_comments/index", type: :view do
  before(:each) do
    assign(:visit_comments, [
      VisitComment.create!(
        appartment: nil,
        contact: "Contact",
        address: "Address",
        extra_comments: "Extra Comments",
        elevator_status: 2,
        balcony: 3,
        view: 4,
        water_key_status: 5,
        water_pressure: 6
      ),
      VisitComment.create!(
        appartment: nil,
        contact: "Contact",
        address: "Address",
        extra_comments: "Extra Comments",
        elevator_status: 2,
        balcony: 3,
        view: 4,
        water_key_status: 5,
        water_pressure: 6
      )
    ])
  end

  it "renders a list of visit_comments" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Contact".to_s, count: 2
    assert_select "tr>td", text: "Address".to_s, count: 2
    assert_select "tr>td", text: "Extra Comments".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: 5.to_s, count: 2
    assert_select "tr>td", text: 6.to_s, count: 2
  end
end
