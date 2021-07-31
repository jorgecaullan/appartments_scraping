require 'rails_helper'

RSpec.describe "visit_comments/show", type: :view do
  before(:each) do
    @visit_comment = assign(:visit_comment, VisitComment.create!(
      appartment: nil,
      contact: "Contact",
      address: "Address",
      extra_comments: "Extra Comments",
      elevator_status: 2,
      balcony: 3,
      view: 4,
      water_key_status: 5,
      water_pressure: 6
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Contact/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Extra Comments/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
  end
end
