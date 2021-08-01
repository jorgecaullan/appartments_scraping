desc "Get appartments from all filters urls"
task get_appartments: :environment do
  filters = Filter.all
  all_external_ids = []
  createds = 0
  filters.each do |filter|
    p "Getting appartments urls on #{filter.commune}"
    urls = filter.get_appartments_urls

    urls.each do |url|
      begin
        resp = Faraday.get(url)
        body = resp.body.force_encoding("utf-8")
        appartment_data = {
          url: url,
          filter_id: filter.id,
        }

        external_id_regex = /Publicación <span class="ui-pdp-color--BLACK ui-pdp-family--SEMIBOLD">#(\d*)<\/span>/
        external_id = body.scan(external_id_regex)[0][0]
        all_external_ids.push(external_id)
        existant = Appartment.find_by(external_id: external_id)
        unless existant.nil?
          p "Skipped #{external_id} (/appartments/#{existant.id})"
          next
        end
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
        appartment_data[:bedrooms] = bedrooms

        # # bathrooms
        bathrooms_regexp = />Ba.os[^\d]*(\d*)/
        bathrooms = body.scan(bathrooms_regexp)[0][0]
        appartment_data[:bathrooms] = bathrooms

        # floor
        floor_regexp = /N.mero de piso de la unidad[^\d]*(\d*)/
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

        # latitude & longitude
        location_regexp = /maptype=roadmap&scale=1&format=jpg&center=([-\d\.]*)%2C([-\d\.]*)&zoom=16/
        location = body.scan(location_regexp)[0]
        latitude = location[0]
        appartment_data[:latitude] = latitude
        longitude = location[1]
        appartment_data[:longitude] = longitude

        appartment = Appartment.new(appartment_data)
        raise appartment.errors unless appartment.save
        createds += 1
        p "Created /appartments/#{appartment.id}"
      rescue => e
        p "Error on create #{url}"
        p e
      end
    end
  end
  p "Appartments createds: #{createds}"
  p "Appartments skiped: #{all_external_ids.length - createds}"
  p 'Analizing previous appartments'
  appartments = Appartment
    .where.not(external_id: all_external_ids)
    .where(sold_out: nil)
  appartments.each do |appartment|
    resp = Faraday.get(appartment.url)
    body = resp.body.force_encoding("utf-8")
    finished_regexp1 = />Publicaci.n finalizada</
    finished = body.scan(finished_regexp1)[0]
    unless finished.nil?
      appartment.sold_out = true
      appartment.sold_date = Time.zone.now
    else
      appartment.rejected = true
      appartment.reject_reason = 'La publicacion ya no coincide con los filtros'
    end
    appartment.save
  end
  if appartments.count > 0
    p "Updated sold appartments (#{appartments.count})"
  else
    p 'Not sold appartments found'
  end
end
