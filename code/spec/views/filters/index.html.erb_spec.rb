require 'rails_helper'

RSpec.describe "filters/index", type: :view do
  before(:each) do
    assign(:filters, [
      Filter.create!(
        url: "Url",
        commune: "Commune",
        bedrooms_range: "Bedrooms Range",
        bathrooms_range: "Bathrooms Range",
        price_range: "Price Range",
        useful_surface_range: "Useful Surface Range",
        parking: false
      ),
      Filter.create!(
        url: "Url",
        commune: "Commune",
        bedrooms_range: "Bedrooms Range",
        bathrooms_range: "Bathrooms Range",
        price_range: "Price Range",
        useful_surface_range: "Useful Surface Range",
        parking: false
      )
    ])
  end

  it "renders a list of filters" do
    render
    assert_select "tr>td", text: "Url".to_s, count: 2
    assert_select "tr>td", text: "Commune".to_s, count: 2
    assert_select "tr>td", text: "Bedrooms Range".to_s, count: 2
    assert_select "tr>td", text: "Bathrooms Range".to_s, count: 2
    assert_select "tr>td", text: "Price Range".to_s, count: 2
    assert_select "tr>td", text: "Useful Surface Range".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
