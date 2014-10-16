require 'active_support/concern'

module Concerns
  module Copyable

    extend ActiveSupport::Concern

    def copy from
      copied_fields.each { |field| self.copy_field(field, from) }
      self
    end

    def copy_field field, from
      self.send("#{field}=", from.send(field))
    end

    def copied_fields
      []
    end

  end
end