# == Schema Information
#
# Table name: documents
#
#  id        :integer          not null, primary key
#  file_uid  :string
#  mime_type :string
#  trip_id   :integer
#  name      :string
#

module Travels
  class Document < ApplicationRecord
    extend Dragonfly::Model
    extend Dragonfly::Model::Validations

    EXTENSIONS = Rack::Mime::MIME_TYPES.invert

    belongs_to :trip, class_name: 'Travels::Trip'

    dragonfly_accessor :file do
      storage_options do |attachment|
        {
            path: "#{generate_path(attachment.name)}/#{attachment.name}"
        }
      end
    end

    validates_presence_of :name, :file, :mime_type

    def store(file)
      self.file = file
      self.file.name = "#{SecureRandom.uuid.gsub('-', '')}#{File.extname(self.file.name)}" if self.file.present?
    end

    def generate_path file_name
      digest = Digest::MD5.hexdigest(file_name)
      "#{digest[0, 2]}/#{digest[2, 2]}/#{digest[4, 2]}/#{digest[6, 10]}"
    end

    def extension
      EXTENSIONS[self.mime_type] || '.txt'
    end

    def as_json(**_args)
      res = super(except: [:file_uid, :trip_id])
      res['icon'] = ApplicationController.helpers.image_tag("filetypes/#{self.extension.gsub('.', '')}.png")
      res
    end
  end
end
