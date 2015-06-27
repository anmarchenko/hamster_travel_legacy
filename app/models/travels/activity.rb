module Travels

  class Activity < ActiveRecord::Base

    include Concerns::Ordered
    include Concerns::Copyable

    belongs_to :day, class_name: 'Travels::Day'

    monetize :amount_cents

    def link_description
      return '' if self.link_url.blank?
      if !self.link_url.start_with?('http://') && !self.link_url.start_with?('https://')
        self.link_url = "http://#{self.link_url}"
      end
      ExternalLink.new(url: link_url).description
    end

    PERMITTED = %w(name amount_cents amount_currency comment link_description link_url order_index id)

    def as_json(**args)
      attrs = super(args)
      attrs['id'] = id.to_s
      attrs = attrs.reject{|k, _| !PERMITTED.include?(k)}
      attrs['amount_cents'] = amount_cents / 100
      attrs['amount_currency_text'] = amount.currency.symbol
      attrs
    end

  end

end