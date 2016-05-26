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

  end
end