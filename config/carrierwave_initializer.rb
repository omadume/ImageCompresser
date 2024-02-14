# Does not work from within config/initializers folder - seems to have some race conditions with rails app initializer
require 'rails_helper'

# Set storage type to local file system and disable file processing when in test environment
if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  # Separate test uploads from regular uploads
  CarrierWave::Uploader::Base.descendants.each do |className|
    next if className.anonymous?
    className.class_eval do
      def cache_dir
        "#{Rails.root}/uploads/tmp"
      end
  
      def store_dir
        "#{Rails.root}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
  
end