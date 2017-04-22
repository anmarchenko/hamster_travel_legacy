# frozen_string_literal: true

module Trips
  module Transfers
    def self.list(day)
      day.transfers.ordered
    end
  end
end
