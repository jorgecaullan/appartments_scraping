class Appartment < ApplicationRecord
  belongs_to :filter
  has_one :visit_comment
end
