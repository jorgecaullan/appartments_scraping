class Appartment < ApplicationRecord
  belongs_to :filter
  has_one :visit_comment

  def self.create_from_url

    return true
  end
end
