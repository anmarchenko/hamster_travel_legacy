# frozen_string_literal: true

module Views
  module HotelView
    def self.show_json(hotel, current_user = nil)
      hotel.as_json
           .merge(
             'id' => hotel.id.to_s,
             'links' => LinkView.index_json(
               Trips::Links.list_hotel(hotel)
             )
           ).merge(
             Views::AmountView.show_json(hotel.amount, current_user)
           )
    end
  end
end
