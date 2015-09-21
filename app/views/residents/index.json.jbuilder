json.array!(@residents) do |resident|
  json.extract! resident, :id, :resident_name, :house_number, :email, :telephone
  json.url resident_url(resident, format: :json)
end
