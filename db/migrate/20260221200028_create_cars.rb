class CreateCars < ActiveRecord::Migration[8.1]
  def change
    create_table :cars do |t|
      t.string :model
      t.integer :year 
      t.string :color
      t.boolean :electric
      t.boolean :is_selling

      t.timestamps   
    end
  end
end