class AddImageUrlToActivities < ActiveRecord::Migration[8.1]
  def change
    add_column :activities, :image_url, :string
  end
end
