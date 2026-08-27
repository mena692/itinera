class AddImageUrlToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :image_url, :string
  end
end
