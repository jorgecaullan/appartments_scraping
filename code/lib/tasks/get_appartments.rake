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
        appartment_data = Appartment.get_appartment_from_url(url)
        all_external_ids.push(appartment_data[:external_id])
        next if appartment_data[:existant]

        appartment = Appartment.new({ filter_id: filter.id, **appartment_data })
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
    finished_regexp = />Publicaci.n (?:finalizada|pausada)</
    finished = body.scan(finished_regexp)[0]
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
    p "Updated sold/rejected appartments (#{appartments.count})"
  else
    p 'Not sold appartments found'
  end
end
