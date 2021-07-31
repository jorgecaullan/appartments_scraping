require 'rails_helper'

RSpec.describe "appartments/index", type: :view do
  before(:each) do
    assign(:appartments, [
      Appartment.create!(
        filter: nil,
        external_id: "External",
        url: "Url",
        cost: 2,
        common_expenses: 3,
        bedrooms: 4,
        bathrooms: 5,
        floor: 6,
        orientation: "Orientation",
        useful_surface: 7,
        total_surface: 8,
        latitude: 9.5,
        longitude: 10.5,
        sold_out: false,
        rejected: false,
        reject_reason: "Reject Reason"
      ),
      Appartment.create!(
        filter: nil,
        external_id: "External",
        url: "Url",
        cost: 2,
        common_expenses: 3,
        bedrooms: 4,
        bathrooms: 5,
        floor: 6,
        orientation: "Orientation",
        useful_surface: 7,
        total_surface: 8,
        latitude: 9.5,
        longitude: 10.5,
        sold_out: false,
        rejected: false,
        reject_reason: "Reject Reason"
      )
    ])
  end

  it "renders a list of appartments" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "External".to_s, count: 2
    assert_select "tr>td", text: "Url".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: 5.to_s, count: 2
    assert_select "tr>td", text: 6.to_s, count: 2
    assert_select "tr>td", text: "Orientation".to_s, count: 2
    assert_select "tr>td", text: 7.to_s, count: 2
    assert_select "tr>td", text: 8.to_s, count: 2
    assert_select "tr>td", text: 9.5.to_s, count: 2
    assert_select "tr>td", text: 10.5.to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: "Reject Reason".to_s, count: 2
  end
end
