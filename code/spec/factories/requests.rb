FactoryBot.define do
  factory :request do
    url { "MyString" }
    rest_method { 1 }
    paginated { false }
  end
end
