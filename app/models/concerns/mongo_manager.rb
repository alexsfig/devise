class MongoManager

  DBNAME              = 'test_mgb'
  API_COLLECTION     = 'users'
  
  def initialize
  end

  def db
    $mongo_client.db(DBNAME)
  end

  def api_collection
    col = db.collection(API_COLLECTION)
    unless col.nil?
      col = db.create_collection(API_COLLECTION)
    end
    return col
  end

  def add_api(user, api)
      u = find_api((user.id.to_s+api.id.to_s))
      if u.nil?
        u = api_collection.insert(
          {
            '_id' => (user.id.to_s+api.id.to_s), created: api.created_at.try(:utc), updated_at: api.updated_at.try(:utc)}.reverse_merge!(api.as_json(:except => [:created_at, :updated_at]).reverse_merge!(user.as_json(:except => [:created_at, :updated_at])) )
          
          )
      end
    return u
  end

  def remove_api(_id)
    api = find_api(_id)
    unless api.nil?
      api = api_collection.remove({ _id: _id})
    end
    return api
  end

  def update_api(user, api)
    a = find_api((user.id.to_s+api.id.to_s))
    unless a.nil?
    doc = {api_name: api.api_key}
      a = api_collection.update({_id: (user.id.to_s+api.id.to_s)}, {created: api.created_at.try(:utc), updated: api.updacdted_at.try(:utc)}.reverse_merge!(api.as_json(:except => [:created_at, :updated_at]).reverse_merge!(user.as_json(:except => [:created_at, :updated_at]))))
    end
  end

  def find_api(_id)
    api_collection.find_one({'_id' => _id})
  end

  def clear_collections
    api_collection.remove({})
  end

end
