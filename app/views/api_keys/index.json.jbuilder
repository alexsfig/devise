json.array!(@api_keys) do |api_key|
  json.extract! api_key, :id, :user, :name, :type_api, :api_key
  json.url api_key_url(api_key, format: :json)
end
