FactoryBot.define do
  factory :visit_comment do
    appartment { nil }
    visit_date_time { "2021-07-29 02:28:28" }
    contact { "MyString" }
    address { "MyString" }
    extra_comments { "MyString" }
    elevator_status { 1 }
    balcony { 1 }
    view { 1 }
    water_key_status { 1 }
    water_pressure { 1 }
  end
end
