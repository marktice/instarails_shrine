require "image_processing/mini_magick"

class ImageUploader < Shrine
  plugin :processing
  plugin :versions, names: [:original, :thumb, :medium]
  plugin :delete_raw # delete processed files after uploading

  process(:store) do |io, context|
    original = io.download
    pipeline = ImageProcessing::MiniMagick.source(original)

    size_80 = pipeline.resize_to_limit!(80, 80)
    size_300 = pipeline.resize_to_limit!(300, 300)

    original.close!

    # return hash of three types of same image
    { original: io, thumb: size_80, medium: size_300 }
  end
end