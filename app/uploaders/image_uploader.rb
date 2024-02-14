require 'carrierwave-imageoptimizer'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageOptimizer

  # Type of storage to use for this uploader
  storage :file # TODO: would be good to switch to fog for a real-world scenario, with rake task to destroy all uploads in bulk daily perhaps
  # storage :fog

  # Override the directory where uploaded files will be stored
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Compress uploaded file (happens before storing)
  process :compress_image

  # Specifying the compression value dynamically
  def compress_image
    return unless file.content_type.start_with?('image/')

    compression_level = model.compression
    ::ImageOptimizer.new(current_path, { quality: compression_level }).optimize
  end

  # An list of extensions which are allowed to be uploaded
  def extension_allowlist
    %w(jpg jpeg)
  end
  
end
