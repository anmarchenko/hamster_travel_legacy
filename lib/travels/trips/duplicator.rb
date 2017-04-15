# frozen_string_literal: true

module Trips
  module Duplicator
    EXCLUDED_FIELDS = %i[short_description private comment image_uid].freeze
    COPIED_FIELDS = [
      {
        days: [
          :places,
          :activities,
          { transfers: :links },
          { hotel: :links },
          :expenses,
          :links
        ]
      },
      :caterings
    ].freeze

    def self.duplicate(trip)
      res = trip.deep_clone(include: COPIED_FIELDS, except: EXCLUDED_FIELDS)
      res.name = "#{res.name} (#{I18n.t('common.copy')})"
      res
    end
  end
end
