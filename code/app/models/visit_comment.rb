class VisitComment < ApplicationRecord
  belongs_to :appartment

  enum elevator_status: [:bad, :normal, :good, :very_good], _prefix: :elevator_status
  enum balcony: [:bad, :normal, :good, :very_good], _prefix: :balcony
  enum view: [:bad, :normal, :good, :very_good], _prefix: :view
  enum water_key_status: [:bad, :normal, :good, :very_good], _prefix: :water_key_status
  enum water_pressure: [:bad, :normal, :good, :very_good], _prefix: :water_pressure
end
