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

    values_diference = worst_value - best_value
    values_diference = 1 if values_diference == 0

    red = ((current_value - best_value)*(worst_color_red - best_color_red))/values_diference + best_color_red
    green = ((current_value - best_value)*(worst_color_green - best_color_green))/values_diference + best_color_green
    blue = ((current_value - best_value)*(worst_color_blue - best_color_blue))/values_diference + best_color_blue

    return "rgb(#{red}, #{green}, #{blue})"
  end

  def self.get_appartment_from_url(url, skip_existant = true, create_test_txt = false)
    resp = Faraday.get(url)
    body = resp.body.force_encoding("utf-8")
    File.open('log/appartments_response.txt', 'w') {|file| file.write(body)} if create_test_txt
    appartment_data = {
      url: url
    }

    external_id_regex = /Publicación <span class="ui-pdp-color--BLACK ui-pdp-family--SEMIBOLD">#(\d*)<\/span>/
    external_id = body.scan(external_id_regex)[0][0]
    appartment_data[:external_id] = external_id
    existant = Appartment.find_by(external_id: external_id)
    unless existant.nil?
      appartment_data[:existant] = true
      if skip_existant
        p "Skipped #{external_id} (/appartments/#{existant.id})"
        return appartment_data
      end
    end

    published_regex = />Publicado hace (\d*) ([^<\s]*)/
    published_data = body.scan(published_regex)[0]
    pub_number = published_data[0]
    published = Time.zone.now
    case published_data[1]
    when /d.as?/
      published -= pub_number.to_i.days
    when /mese?s?/
      published -= pub_number.to_i.days
    else
      published
    end
    appartment_data[:published] = published

    # cost
    cost_regexp = /\$<\/span><span class="price-tag-fraction">([\d\.]*)<\/span>/
    cost = body.scan(cost_regexp)[0][0].gsub('.', '')
    appartment_data[:cost] = cost

    # common_expenses
    common_expenses_regexp1 = /id":"Gastos comunes","text":"(\d*) /
    common_expenses = body.scan(common_expenses_regexp1)[0]
    if common_expenses.nil?
      common_expenses_regexp2 = /[Gg](?:astos\s)?[Cc](?:omunes)?[\sdeaproximsn\$]*([\d\.]*)/
      common_expenses = body.scan(common_expenses_regexp2)[0]
    end
    common_expenses = common_expenses[0].gsub('.', '') unless common_expenses.nil?
    appartment_data[:common_expenses] = common_expenses

    # bedrooms
    bedrooms_regexp = />Dormitorios[^\d]*(\d*)/
    bedrooms = body.scan(bedrooms_regexp)[0][0]
    appartment_data[:bedrooms] = bedrooms

    # bathrooms
    bathrooms_regexp = />Ba.os[^\d]*(\d*)/
    bathrooms = body.scan(bathrooms_regexp)[0][0]
    appartment_data[:bathrooms] = bathrooms

    # floor
    floor_regexp1 = /N.mero de piso de la unidad[^\d]*(\d*)/
    floor = body.scan(floor_regexp1)[0]
    if floor.nil?
      floor_regexp2 = /[Pp]iso\s?(\d{1,2})/
      floor = body.scan(floor_regexp2)[0]
    end
    floor = floor[0] unless floor.nil?
    appartment_data[:floor] = floor

    # orientation
    orientation_regexp1 = />Orientaci.n[^NOPS]*([NOPS]+)/
    orientation = body.scan(orientation_regexp1)[0]
    if orientation.nil?
      orientation_regexp2 = /(?:[Oo]rientaci.n|[Vv]ista)\s([nNpPoOsSrietu-]*)/
      orientation = body.scan(orientation_regexp2)[0]
    end
    orientation = orientation[0] unless orientation.nil?
    appartment_data[:orientation] = orientation

    # useful_surface
    useful_surface_regexp = /id":"Superficie .til","text":"(\d*)[\.\s]/
    useful_surface = body.scan(useful_surface_regexp)[0][0]
    appartment_data[:useful_surface] = useful_surface

    # total_surface
    total_surface_regexp = /id":"Superficie total","text":"(\d*)[\.\s]/
    total_surface = body.scan(total_surface_regexp)[0][0]
    appartment_data[:total_surface] = total_surface

    # duplex
    duplex_regexp = /([Dd][uú]plex)/
    duplex = body.scan(duplex_regexp)[0]
    duplex = true unless duplex.nil?
    appartment_data[:duplex] = duplex

    # walk_in_closet
    walk_in_closet_regexp = /[Ww]alk[-\s]?[Ii]ng?[-\s]?[Cc]l[oó]set/
    walk_in_closet = body.scan(walk_in_closet_regexp)[0]
    walk_in_closet = true unless walk_in_closet.nil?
    appartment_data[:walk_in_closet] = walk_in_closet

    # latitude & longitude
    location_regexp = /maptype=roadmap&scale=1&format=jpg&center=([-\d\.]*)%2C([-\d\.]*)&zoom=16/
    location = body.scan(location_regexp)[0]
    latitude = location[0]
    appartment_data[:latitude] = latitude
    longitude = location[1]
    appartment_data[:longitude] = longitude

    return appartment_data
  end

  private
    def set_nils
      self.sold_out = nil if self.sold_out == false
      self.rejected = nil if self.rejected == false
      self.duplex = nil if self.duplex == false
      self.walk_in_closet = nil if self.walk_in_closet == false
    end
end
