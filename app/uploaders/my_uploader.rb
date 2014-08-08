class MyUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  version :thumb do
    process resize_to_fill: [280, 280]
  end
end