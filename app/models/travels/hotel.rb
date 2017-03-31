# frozen_string_literal: true

# == Schema Information
#
# Table name: hotels
#
#  id              :integer          not null, primary key
#  name            :string
#  comment         :text
#  day_id          :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#

module Travels
  class Hotel < ApplicationRecord
    belongs_to :day, class_name: 'Travels::Day'
    has_many :links, class_name: 'ExternalLink', as: :linkable

    monetize :amount_cents, allow_nil: true

    def serializable_hash(_args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['links'] = if links.blank?
                        [{}]
                      else
                        links
                      end
      json['amount_currency_text'] = amount.currency.symbol
      json
    end

    def empty_content?
      %i(name comment).each do |field|
        return false unless send(field).blank?
      end
      (links || []).each do |link|
        return false unless link.url.blank?
      end
      true
    end
  end
end
