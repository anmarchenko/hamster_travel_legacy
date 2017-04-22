# frozen_string_literal: true

module Views
  module PlaceView
    def self.index_json(places)
      places.map { |place| show_json(place) }
    end

    def self.show_json(place)
      place.as_json
           .merge(
             'id' => place.id.to_s,
             'city_text' => place.city_text,
             'flag_image' => Views::FlagView.flag(place.country_code)
           )
    end
  end
end
