class AddDescriptionToUploadedImage < ActiveRecord::Migration[6.0]
  def change
    add_column :uploaded_images, :description, :string
  end
end
