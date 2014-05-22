require 'active_support/concern'

module Concerns
  module Ordered
    extend ActiveSupport::Concern

    included do
      field :order_index, type: Integer

      default_scope ->{order_by(order_index: 1)}

      index({order_index: 1}, {unique: true})
    end

    def as_json(**args)
      attrs = super(args)
      attrs['order_index'] = self.order_index
      attrs
    end

  end
end