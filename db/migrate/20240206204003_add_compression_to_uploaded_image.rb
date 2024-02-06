class AddCompressionToUploadedImage < ActiveRecord::Migration[6.0]
  def change
    add_column :uploaded_images, :compression, :integer
  end
end
