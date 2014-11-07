require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave/processing/mini_magick'

#
# Carrierwave Config
#
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    :region                 => 'us-west-1'
  }
  config.fog_directory  = 'duckspace-images'
  config.fog_public     = true
end

#
# Carrierwave Uploader
#
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog
  process :auto_orient
  version :thumb do
    process :resize_to_fill => [200,200]
  end
  def store_dir
    ENV['RACK_ENV'].nil? ? (primary_folder = "test") : (primary_folder = ENV['RACK_ENV'])
    "#{primary_folder}/uploads/posts/#{model.id}/images"
  end
  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end
end
