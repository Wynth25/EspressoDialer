json.extract! basket, :id, :name, :min_dose, :max_dose, :created_at, :updated_at
json.url basket_url(basket, format: :json)
