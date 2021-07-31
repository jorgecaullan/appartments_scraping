require 'rails_helper'

RSpec.describe "appartments/edit", type: :view do
  before(:each) do
    @appartment = assign(:appartment, Appartment.create!(
      filter: nil,
      external_id: "MyString",
      url: "MyString",
      cost: 1,
      common_expenses: 1,
      bedrooms: 1,
      bathrooms: 1,
      floor: 1,
      orientation: "MyString",
      useful_surface: 1,
      total_surface: 1,
      latitude: 1.5,
      longitude: 1.5,
      sold_out: false,
      rejected: false,
      reject_reason: "MyString"
    ))
  end

  it "renders the edit appartment form" do
    render

    assert_select "form[action=?][method=?]", appartment_path(@appartment), "post" do

      assert_select "input[name=?]", "appartment[filter_id]"

      assert_select "input[name=?]", "appartment[external_id]"

      assert_select "input[name=?]", "appartment[url]"

      assert_select "input[name=?]", "appartment[cost]"

      assert_select "input[name=?]", "appartment[common_expenses]"

      assert_select "input[name=?]", "appartment[bedrooms]"

      assert_select "input[name=?]", "appartment[bathrooms]"

      assert_select "input[name=?]", "appartment[floor]"

      assert_select "input[name=?]", "appartment[orientation]"

      assert_select "input[name=?]", "appartment[useful_surface]"

      assert_select "input[name=?]", "appartment[total_surface]"

      assert_select "input[name=?]", "appartment[latitude]"

      assert_select "input[name=?]", "appartment[longitude]"

      assert_select "input[name=?]", "appartment[sold_out]"

      assert_select "input[name=?]", "appartment[rejected]"

      assert_select "input[name=?]", "appartment[reject_reason]"
    end
  end
end
