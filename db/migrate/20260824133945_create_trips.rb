class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.text :description
      t.string :destination
      t.integer :group_size
      t.string :vibe
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
