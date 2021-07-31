desc "Get appartments from all filters urls"
task get_appartments: :environment do
  filters = Filter.all
  filters.each do |filter|
    p 'Getting appartments urls'
    urls = filter.get_appartments_urls

    urls.each do |url|
      p "Analyzing #{url}"
      begin
        resp = Faraday.get(url)
        body = resp.body.force_encoding("utf-8")
        appartment_data = {
          url: url,
          filter_id: filter.id,
        }

        external_id_regex = /Publicación <span class="ui-pdp-color--BLACK ui-pdp-family--SEMIBOLD">#(\d*)<\/span>/
        external_id = body.scan(external_id_regex)[0][0]
        existant = Appartment.find_by(external_id: external_id)
        unless existant.nil?
          p 'Skipped'
          next # skip if already exist
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
        bedrooms_regexp = /Dormitorios[^\d]*(\d*)/
        bedrooms = body.scan(bedrooms_regexp)[0][0]
        appartment_data[:bedrooms] = bedrooms

        # # bathrooms
        bathrooms_regexp = /Baños[^\d]*(\d*)/
        bathrooms = body.scan(bathrooms_regexp)[0][0]
        appartment_data[:bathrooms] = bathrooms

        # floor
        floor_regexp = /N.mero de piso de la unidad[^\d]*(\d*)/
        floor = body.scan(floor_regexp)[0]
        floor = floor[0] unless floor.nil?
        appartment_data[:floor] = floor

        # orientation
        orientation_regexp1 = /Orientaci.n[^\d]*([nNpPoOsS]*)/
        orientation = body.scan(orientation_regexp1)[0]
        if orientation.nil?
          orientation_regexp2 = /[Oo]rientaci.n\s([nNpPoOsSrietu-]*)/
          orientation = body.scan(orientation_regexp2)[0]
        end
        orientation = orientation[0] unless orientation.nil?
        appartment_data[:orientation] = orientation

        # useful_surface
        useful_surface_regexp = /id":"Superficie .til","text":"(\d*) /
        useful_surface = body.scan(useful_surface_regexp)[0][0]
        appartment_data[:useful_surface] = useful_surface

        # total_surface
        total_surface_regexp = /id":"Superficie total","text":"(\d*) /
        total_surface = body.scan(total_surface_regexp)[0][0]
        appartment_data[:total_surface] = total_surface

        # latitude & longitude
        location_regexp = /maptype=roadmap&scale=1&format=jpg&center=([-\d\.]*)%2C([-\d\.]*)&zoom=16/
        location = body.scan(location_regexp)[0]
        latitude = location[0]
        appartment_data[:latitude] = latitude
        longitude = location[1]
        appartment_data[:longitude] = longitude

        appartment = Appartment.new(appartment_data)
        appartment.save
        p 'Created'
      rescue => e
        p "Error on create"
        p e
      end
    end
  end
  p 'Appartments created'
end

# to generate a txt file to analize regexp from an url, use:
# resp = Faraday.get "https://www.portalinmobiliario.com/MLC-612229835-av-providencia-1072-condominio-avenida-providencia-1072-_JM#position=9&amp;search_layout=stack&amp;type=item&amp;tracking_id=e66a070c-d8cd-40bc-9676-a26cf9535079"
# File.open('log/appartments_response.txt', 'w') {|file| file.write(resp.body.force_encoding("utf-8"))}

# example data used
# urls = [
#   "https://www.portalinmobiliario.com/MLC-633970102-estupenda-ubicacion-metro-cercano-edificio-tranquilo-_JM#position=1&amp;search_layout=stack&amp;type=item&amp;tracking_id=5ddf8a21-ea09-41bb-8cd2-b0b7ab57f054",
#   "https://www.portalinmobiliario.com/arriendo/departamento/providencia-metropolitana/6260698-europa-uda#position=5&search_layout=stack&type=item&tracking_id=f76281d9-8c9a-4ce3-8df5-6850d3f2e99b"
# ]