class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.text :notes
      t.string :category
      t.float :latitude
      t.float :longitude
      t.string :address
      t.references :trip_day, null: false, foreign_key: true

      t.timestamps
    end
  end
end
