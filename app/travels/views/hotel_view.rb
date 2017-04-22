# frozen_string_literal: true

module Views
  module HotelView
    def self.show_json(hotel)
      hotel.as_json
           .merge(
             'id' => hotel.id.to_s,
             'amount_currency_text' => hotel.amount.currency.symbol,
             'links' => LinkView.index_json(
               Trips::Links.list_hotel(hotel)
             )
           )
    end
  end
end
