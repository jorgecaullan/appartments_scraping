class Appartment < ApplicationRecord
  belongs_to :filter
  has_one :visit_comment

  before_save :set_nils

  def self.set_color(best_value, worst_value, current_value)
    best_color_red = 87
    best_color_green = 187
    best_color_blue = 138

    worst_color_red = 244
    worst_color_green = 199
    worst_color_blue = 195

    red = (((current_value - best_value)*(worst_color_red - best_color_red))/(worst_value - best_value)) + best_color_red
    green = (((current_value - best_value)*(worst_color_green - best_color_green))/(worst_value - best_value)) + best_color_green
    blue = (((current_value - best_value)*(worst_color_blue - best_color_blue))/(worst_value - best_value)) + best_color_blue

    return "rgb(#{red}, #{green}, #{blue})"
  end

  private
    def set_nils
      self.sold_out = nil if self.sold_out == false
      self.rejected = nil if self.rejected == false
      self.duplex = nil if self.duplex == false
    end
end
