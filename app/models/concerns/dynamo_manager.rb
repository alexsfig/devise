class DynamoManager

  DATABASE_NAME = 'test_dynamo'
  def initalize
    
  end

  def db 
    db = $dynamodb
  end

  def create_table
    unless if_exist?
      begin
        db.describe_table(:table_name => DATABASE_NAME)
      rescue Aws::DynamoDB::Errors::ResourceNotFoundException
        db.create_table(
          :table_name => DATABASE_NAME,
          :attribute_definitions => [
            {
              :attribute_name => :id,
              :attribute_type => :S
            }
          ],
          :key_schema => [
            {
              :attribute_name => :id,
              :key_type => :HASH
            }
          ],
          :provisioned_throughput => {
            :read_capacity_units => 1,
            :write_capacity_units => 1,
          }
        )

          # wait for table to be created
        puts "waiting for table to be created..."
        db.wait_until(:table_exists, table_name: DATABASE_NAME)
        puts "table created!"
      end
    else 
      puts "table exist"
    end
  end
  
  def insert data
    unless data.empty? 
      db.put_item(:table_name => 'test_dynamo', :item => data)   
    end 
  end
  def update data
    unless data.empty?
      if item_exist data['id']
        resp = db.update_item(
          # required
          table_name: DATABASE_NAME,
          # required
          key: {
            "id" => data['id'], #<Hash,Array,String,Numeric,Boolean,nil,IO,Set>,
          },
          attribute_updates: {
            "name" => {
              value: data['name'], #<Hash,Array,String,Numeric,Boolean,nil,IO,Set>,
              action: "PUT",
            },
            "api_key" => {
              value: data['api_key'], #<Hash,Array,String,Numeric,Boolean,nil,IO,Set>,
              action: "PUT",
            }
          }
        )
      end
    end
  end

  def delete id
    unless id.nil? 
      if item_exist id
        db.delete_item(:table_name => DATABASE_NAME, key: {
          "id" => id, #<Hash,Array,String,Numeric,Boolean,nil,IO,Set>,
        }) 
      end  
    end 
  end
  private
  def item_exist id
    req = true
    resp = db.get_item(
      table_name: DATABASE_NAME,
      key: {
        "id" => id
      }
    )
    req = false if resp.item.nil?
    return req
  end

  def if_exist?
    req = true
    begin
      db.scan(table_name: DATABASE_NAME)
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException
      req = false
    end
    return req
  end


end