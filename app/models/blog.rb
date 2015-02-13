class Blog
  include Cequel::Record
  key :subdomain, :text
  column :name, :text
  column :type_key, :text
  column :user, :text
  column :api_key, :text
  timestamps
end