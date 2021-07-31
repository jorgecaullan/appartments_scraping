require 'rails_helper'

RSpec.describe "appartments/show", type: :view do
  before(:each) do
    @appartment = assign(:appartment, Appartment.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/External/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/Orientation/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9.5/)
    expect(rendered).to match(/10.5/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Reject Reason/)
  end
end
