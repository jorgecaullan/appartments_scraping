FactoryBot.define do
  factory :field_response do
    name { "MyString" }
    location { "MyString" }
    header { false }
    regexp { "MyString" }
    type { 1 }
    response { nil }
  end
end
