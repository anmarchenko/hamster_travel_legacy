require 'active_support/concern'

module Concerns
  module ImageUploading

    extend ActiveSupport::Concern

    def save_image object, image, size
      object.image = image
      if object.image && object.valid?
        # crop before save
        job = object.image.convert("-crop #{params[:w]}x#{params[:h]}+#{params[:x]}+#{params[:y]}") rescue nil
        if job
          job.apply
          object.image = job.content
          object.image = object.image.thumb(size)
        end
      end

      object.save
    end

    VALID_IMAGE_SIGNATURES = [
        "\x89PNG\r\n\x1A\n".force_encoding(Encoding::ASCII_8BIT), # PNG
        "GIF87a".force_encoding(Encoding::ASCII_8BIT), # GIF87
        "GIF89a".force_encoding(Encoding::ASCII_8BIT), # GIF89
        "\xFF\xD8".force_encoding(Encoding::ASCII_8BIT) # JPEG
    ].freeze

    def file_is_image(temporary_file_path)
      return false unless temporary_file_path

      file_stream = File.new(temporary_file_path, 'r')
      first_eight_bytes = file_stream.readpartial(8)
      file_stream.close

      VALID_IMAGE_SIGNATURES.each do |signature|
        return true if first_eight_bytes.start_with?(signature)
      end

      false
    end

  end
end