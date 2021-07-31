FactoryBot.define do
  factory :field do
    name { "MyString" }
    value { "MyString" }
    type { 1 }
    from_response { false }
    field_response_name { "MyString" }
    header { false }
    request { nil }
  end
end
