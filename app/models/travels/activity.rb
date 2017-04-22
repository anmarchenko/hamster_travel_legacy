# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id               :integer          not null, primary key
#  order_index      :integer
#  name             :string
#  comment          :text
#  link_description :string
#  link_url         :text
#  day_id           :integer
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string           default("RUB"), not null
#  rating           :integer          default(2)
#  address          :string
#  working_hours    :string
#

module Travels
  class Activity < ApplicationRecord
    include Concerns::Ordered

    belongs_to :day, class_name: 'Travels::Day'

    monetize :amount_cents

    def link_description
      return '' if link_url.blank?
      if !link_url.start_with?('http://') && !link_url.start_with?('https://')
        self.link_url = "http://#{link_url}"
      end
      ExternalLink.new(url: link_url).description
    end
  end
end
