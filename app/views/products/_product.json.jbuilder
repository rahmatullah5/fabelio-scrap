json.extract! product, :id, :related_link, :description, :title, :sub_title, :current_price, :previous_price, :created_at, :updated_at
json.url product_url(product, format: :json)
