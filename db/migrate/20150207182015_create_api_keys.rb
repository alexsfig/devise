class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :user, index: true
      t.string :name
      t.string :type_api
      t.string :api_key

      t.timestamps
    end
  end
end
