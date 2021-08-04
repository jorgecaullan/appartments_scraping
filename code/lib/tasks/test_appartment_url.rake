desc "Test filters of an appartment url"
task test_appartment_url: :environment do
  url = "https://www.portalinmobiliario.com/arriendo/departamento/providencia-metropolitana/6284642-llewellyn-jones-1252-uda#position=12&amp;search_layout=stack&amp;type=item&amp;tracking_id=9bbdb459-0da4-44c4-8437-6cb9f43713e6"

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
