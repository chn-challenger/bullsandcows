class CreateBullsandcowsgames < ActiveRecord::Migration
  def change
    create_table :bullsandcowsgames do |t|
      t.string :state

      t.timestamps null: false
    end
  end
end
