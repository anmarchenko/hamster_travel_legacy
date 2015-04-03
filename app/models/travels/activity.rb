module Travels

  class Activity < ActiveRecord::Base

    include Concerns::Ordered
    include Concerns::Copyable

    belongs_to :day, class_name: 'Travels::Day'

    def link_description
      return '' if self.link_url.blank?
      if !self.link_url.start_with?('http://') && !self.link_url.start_with?('https://')
        self.link_url = "http://#{self.link_url}"
      end
      ExternalLink.new(url: link_url).description
    end

    PERMITTED = %w(name price comment link_description link_url order_index id)

    def as_json(**args)
      attrs = super(args)
      attrs['id'] = id.to_s
      attrs.reject{|k, _| !PERMITTED.include?(k)}
    end

  end

end