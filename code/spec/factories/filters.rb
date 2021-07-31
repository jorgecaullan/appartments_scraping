FactoryBot.define do
  factory :filter do
    url { "MyString" }
    commune { "MyString" }
    bedrooms_range { "MyString" }
    bathrooms_range { "MyString" }
    price_range { "MyString" }
    useful_surface_range { "MyString" }
    parking { false }
  end
end
