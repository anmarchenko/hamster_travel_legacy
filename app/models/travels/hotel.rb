# == Schema Information
#
# Table name: hotels
#
#  id              :integer          not null, primary key
#  name            :string
#  comment         :text
#  mongo_id        :string
#  day_id          :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#

module Travels
  class Hotel < ActiveRecord::Base
    include Concerns::Copyable

    belongs_to :day, class_name: 'Travels::Day'
    has_many :links, class_name: 'ExternalLink', as: :linkable

    monetize :amount_cents

    def as_json(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      if links.blank?
        json['links'] = [ExternalLink.new].as_json(args)
      else
        json['links'] = links.as_json(args)
      end
      json['amount_currency_text'] = amount.currency.symbol
      json
    end

    def is_empty?
      [:name, :comment].each do |field|
        return false unless self.send(field).blank?
      end
      (links || []).each do |link|
        return false unless link.url.blank?
      end
      return true
    end

    def copied_relations
      ['links']
    end

  end
end
