# frozen_string_literal: true

module Views
  module TransferView
    def self.show_json(transfer, transfer_json = {})
      transfer_json.merge(
        'id' => transfer.id.to_s,
        'start_time' => transfer.start_time&.strftime('%Y-%m-%dT%H:%M+00:00'),
        'end_time' => transfer.end_time&.strftime('%Y-%m-%dT%H:%M+00:00'),
        'type_icon' => transfer.type_icon,
        'amount_currency_text' => transfer.amount.currency.symbol,
        'city_from_text' => transfer.city_from_text,
        'city_to_text' => transfer.city_to_text,
        'links' => index_links_json(transfer)
      )
    end

    def self.index_links_json(transfer)
      transfer.links.blank? ? [{}] : transfer.links
    end
  end
end
