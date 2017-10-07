# frozen_string_literal: true

module Documents
  # CREATE ACTIONS
  def self.create(trip, files)
    # rubocop:disable Performance/HashEachMethods
    files.values.each do |file|
      name = File.basename(
        file.original_filename, File.extname(file.original_filename)
      )
      document = Travels::Document.new(
        name: name, mime_type: file.content_type, trip: trip
      )
      document.store(file)
      document.save
    end
  end
end
