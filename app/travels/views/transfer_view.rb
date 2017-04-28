# frozen_string_literal: true

module Views
  module TransferView
    def self.index_json(transfers, current_user = nil)
      transfers.map { |transfer| show_json(transfer, current_user) }
    end

    # rubocop:disable MethodLength
    # rubocop:disable AbcSize
    def self.show_json(transfer, current_user = nil)
      transfer.as_json.merge(
        'id' => transfer.id.to_s,
        'start_time' => transfer.start_time&.strftime('%Y-%m-%dT%H:%M+00:00'),
        'end_time' => transfer.end_time&.strftime('%Y-%m-%dT%H:%M+00:00'),
        'type_icon' => type_icon(transfer),
        'city_from_text' => transfer.city_from_text,
        'city_to_text' => transfer.city_to_text,
        'links' => Views::LinkView.index_json(
          Trips::Links.list_transfer(transfer)
        )
      ).merge(
        Views::AmountView.show_json(transfer.amount, current_user)
      )
    end

    def self.type_icon(transfer)
      unless transfer.type.blank?
        icon = ActionController::Base.helpers.image_path(
          "transfers/#{Travels::Transfer::Types::ICONS[transfer.type]}"
        )
      end
      icon ||= ActionController::Base.helpers.image_path('transfers/arrow.svg')
      icon
    end
  end
end
