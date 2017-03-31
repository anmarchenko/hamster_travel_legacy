# frozen_string_literal: true

module Creators
  class Trip
    attr_accessor :original

    def initialize(original)
      self.original = original
    end

    def new_trip
      build_trip
    end

    def create_trip(params, user)
      trip = build_trip
      trip.assign_attributes(
        params.merge(author_user_id: user.id, users: [user])
      )
      trip.save
      trip
    end

    private

    def build_trip
      if original.blank?
        Travels::Trip.new
      else
        res = original.deep_clone(
          include: copied_fields, except: excluded_fields
        )
        res.name = "#{res.name} (#{I18n.t('common.copy')})"
        res
      end
    end

    def copied_fields
      [
        {
          days: [:places, :activities,
                 { transfers: :links },
                 { hotel: :links },
                 :expenses, :links]
        },
        :caterings
      ]
    end

    def excluded_fields
      %i(short_description private comment image_uid)
    end
  end
end
