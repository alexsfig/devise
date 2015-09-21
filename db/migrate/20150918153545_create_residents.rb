class CreateResidents < ActiveRecord::Migration
  def change
    create_table :residents do |t|
      t.string :resident_name
      t.string :house_number ,unique: true
      t.string :email        ,unique: true
      t.string :telephone    ,unique: true

      t.timestamps
    end
  end
end
