class MyUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # def filename
  #   @name ||= "#{timestamp}-#{super}" if original_filename.present? and super.present?
  # end

  # def timestamp
  #   var = :"@#{mounted_as}_timestamp"
  #   model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_s(:db))
  # end

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