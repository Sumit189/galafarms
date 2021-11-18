json.extract! product, :id, :product_name, :product_type, :product_brand, :description, :price, :created_at, :updated_at
json.url product_url(product, format: :json)
