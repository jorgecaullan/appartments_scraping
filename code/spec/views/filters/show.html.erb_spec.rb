require 'rails_helper'

RSpec.describe "filters/show", type: :view do
  before(:each) do
    @filter = assign(:filter, Filter.create!(
      url: "Url",
      commune: "Commune",
      bedrooms_range: "Bedrooms Range",
      bathrooms_range: "Bathrooms Range",
      price_range: "Price Range",
      useful_surface_range: "Useful Surface Range",
      parking: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Commune/)
    expect(rendered).to match(/Bedrooms Range/)
    expect(rendered).to match(/Bathrooms Range/)
    expect(rendered).to match(/Price Range/)
    expect(rendered).to match(/Useful Surface Range/)
    expect(rendered).to match(/false/)
  end
end
