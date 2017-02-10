# frozen_string_literal: true
require 'active_support/concern'

module Concerns
  module Ordered
    extend ActiveSupport::Concern

    included do
      default_scope -> { order(order_index: :asc) }
    end

    def as_json(**args)
      attrs = super(args)
      attrs['order_index'] = order_index
      attrs
    end
  end
end
