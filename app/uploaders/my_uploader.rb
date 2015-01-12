class MyUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    if Rails.env.staging? || Rails.env.production?
      "uploads/#{model.class.to_s.underscore}/#{model.id}"
    else
      "#{Rails.root}/public/uploads/#{model.class.to_s.underscore}/#{model.id}"
    end
  end

  def is_landscape?(new_file)
    image = ::MiniMagick::Image::read(File.binread(@file.file))
    image[:width] > image[:height]
  end

  def is_portrait?(new_file)
    image = ::MiniMagick::Image::read(File.binread(@file.file))
    image[:width] < image[:height]
  end

  def is_square?(new_file)
    image = ::MiniMagick::Image::read(File.binread(@file.file))
    image[:width] == image[:height]
  end

  version :thumb do
    process resize_to_fill: [225,149], if: :is_landscape?
    process resize_to_fill: [149,225], if: :is_portrait?
    process resize_to_fill: [149,149], if: :is_square?
  end

end