desc "Test filters of an appartment url"
task test_appartment_url: :environment do
  url = "https://www.portalinmobiliario.com/arriendo/departamento/las-condes-metropolitana/6230618-avenida-presidente-kennedy-uda#position=5&amp;search_layout=stack&amp;type=item&amp;tracking_id=1de782e8-dd60-4bc8-8452-461fdae877b3"

  begin
    appartment_data = Appartment.get_appartment_from_url(url, false, true)

    appartment = Appartment.new({ filter_id: Filter.first.id, **appartment_data }.except(:existant))
    pp appartment
    raise appartment.errors.to_json unless appartment.valid?
    p "Appartment is valid"
  rescue => e
    p "Error on create #{url}"
    p e
  end
end
