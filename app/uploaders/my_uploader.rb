class MyUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def is_landscape?(new_file)
    image = ::MiniMagick::Image::read(File.binread(@file.file))
    image[:width] >= image[:height]
  end

  def is_portrait?(new_file)
    !is_landscape?(new_file)
  end

  version :thumb do
    process resize_to_fill: [225,149], if: :is_landscape?
    process resize_to_fill: [149,225], if: :is_portrait?
  end

end