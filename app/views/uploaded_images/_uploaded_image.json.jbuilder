json.extract! uploaded_image, :id, :image, :created_at, :updated_at
json.url uploaded_image_url(uploaded_image, format: :json)
