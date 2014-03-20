json.array!(@users) do |user|
  json.extract! user, :id, :name, :password, :home_city
  json.url user_url(user, format: :json)
end
