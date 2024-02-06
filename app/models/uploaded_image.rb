class UploadedImage < ApplicationRecord
  validates_presence_of :image, :compression
  mount_uploader :image, ImageUploader
end
