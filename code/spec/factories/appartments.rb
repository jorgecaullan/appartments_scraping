FactoryBot.define do
  factory :appartment do
    filter { nil }
    external_id { "MyString" }
    url { "MyString" }
    cost { 1 }
    common_expenses { 1 }
    bedrooms { 1 }
    bathrooms { 1 }
    floor { 1 }
    orientation { "MyString" }
    useful_surface { 1 }
    total_surface { 1 }
    latitude { 1.5 }
    longitude { 1.5 }
    published { "2021-07-29" }
    sold_out { false }
    sold_date { "2021-07-29" }
    rejected { false }
    reject_reason { "MyString" }
  end
end
