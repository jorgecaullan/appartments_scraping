desc "Test filters of an appartment url"
task test_appartment_url: :environment do
  url = "https://www.portalinmobiliario.com/MLC-625077190-departamento-nunoa-lider-irarrazaval-_JM#position=11&amp;search_layout=stack&amp;type=item&amp;tracking_id=26c343a2-4889-45e3-beb4-3df3860399f6"

  begin
    resp = Faraday.get(url)
    body = resp.body.force_encoding("utf-8")
    File.open('log/appartments_response.txt', 'w') {|file| file.write(body)}

    appartment_data = {
      url: url,
      filter_id: Filter.first.id,
    }

    external_id_regex = /Publicación <span class="ui-pdp-color--BLACK ui-pdp-family--SEMIBOLD">#(\d*)<\/span>/
    external_id = body.scan(external_id_regex)[0][0]
    p 'external_id ok'
    appartment_data[:external_id] = external_id

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
    p 'cost ok'
    appartment_data[:cost] = cost

    # common_expenses
    common_expenses_regexp1 = /id":"Gastos comunes","text":"(\d*) /
    common_expenses = body.scan(common_expenses_regexp1)[0]
    if common_expenses.nil?
      common_expenses_regexp2 = /[Gg]astos comunes[\sdeaproxims\$]*([\d\.]*)/
      common_expenses = body.scan(common_expenses_regexp2)[0]
    end
    common_expenses = common_expenses[0].gsub('.', '') unless common_expenses.nil?
    appartment_data[:common_expenses] = common_expenses

    # bedrooms
    bedrooms_regexp = />Dormitorios[^\d]*(\d*)/
    bedrooms = body.scan(bedrooms_regexp)[0][0]
    p 'bedrooms ok'
    appartment_data[:bedrooms] = bedrooms

    # # bathrooms
    bathrooms_regexp = />Ba.os[^\d]*(\d*)/
    bathrooms = body.scan(bathrooms_regexp)[0][0]
    p 'bathrooms ok'
    appartment_data[:bathrooms] = bathrooms

    # floor
    floor_regexp = />N.mero de piso de la unidad[^\d]*(\d*)/
    floor = body.scan(floor_regexp)[0]
    floor = floor[0] unless floor.nil?
    appartment_data[:floor] = floor

    # orientation
    orientation_regexp1 = />Orientaci.n[^NOPS]*([NOPS]+)/
    orientation = body.scan(orientation_regexp1)[0]
    if orientation.nil?
      orientation_regexp2 = /[Oo]rientaci.n\s([nNpPoOsSrietu-]*)/
      orientation = body.scan(orientation_regexp2)[0]
    end
    orientation = orientation[0] unless orientation.nil?
    appartment_data[:orientation] = orientation

    # useful_surface
    useful_surface_regexp = /id":"Superficie .til","text":"(\d*)[\.\s]/
    p 'error on useful surface'
    useful_surface = body.scan(useful_surface_regexp)[0][0]
    p 'useful_surface ok'
    appartment_data[:useful_surface] = useful_surface

    # total_surface
    total_surface_regexp = /id":"Superficie total","text":"(\d*)[\.\s]/
    total_surface = body.scan(total_surface_regexp)[0][0]
    p 'total_surface ok'
    appartment_data[:total_surface] = total_surface

    # duplex
    duplex_regexp = /([Dd][uú]plex)/
    duplex = body.scan(duplex_regexp)[0]
    duplex = true unless duplex.nil?
    appartment_data[:duplex] = duplex

    # latitude & longitude
    location_regexp = /maptype=roadmap&scale=1&format=jpg&center=([-\d\.]*)%2C([-\d\.]*)&zoom=16/
    location = body.scan(location_regexp)[0]
    latitude = location[0]
    appartment_data[:latitude] = latitude
    longitude = location[1]
    appartment_data[:longitude] = longitude

    appartment = Appartment.new(appartment_data)
    pp appartment
    raise appartment.errors.to_json unless appartment.valid?
    p "Appartment is valid"
  rescue => e
    p "Error on create #{url}"
    p e
  end
end
