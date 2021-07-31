require 'rails_helper'

RSpec.describe "filters/edit", type: :view do
  before(:each) do
    @filter = assign(:filter, Filter.create!(
      url: "MyString",
      commune: "MyString",
      bedrooms_range: "MyString",
      bathrooms_range: "MyString",
      price_range: "MyString",
      useful_surface_range: "MyString",
      parking: false
    ))
  end

  it "renders the edit filter form" do
    render

    assert_select "form[action=?][method=?]", filter_path(@filter), "post" do

      assert_select "input[name=?]", "filter[url]"

      assert_select "input[name=?]", "filter[commune]"

      assert_select "input[name=?]", "filter[bedrooms_range]"

      assert_select "input[name=?]", "filter[bathrooms_range]"

      assert_select "input[name=?]", "filter[price_range]"

      assert_select "input[name=?]", "filter[useful_surface_range]"

      assert_select "input[name=?]", "filter[parking]"
    end
  end
end
