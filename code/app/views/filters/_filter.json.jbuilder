json.extract! filter, :id, :url, :commune, :bedrooms_range, :bathrooms_range, :price_range, :useful_surface_range, :parking, :created_at, :updated_at
json.url filter_url(filter, format: :json)
