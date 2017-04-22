# frozen_string_literal: true

module Cities
  def self.search(term)
    Rails.cache.fetch(
      "cities_by_#{term}_#{I18n.locale}_2016_01_07", expires_in: 1.year.to_i
    ) do
      Geo::City.find_by_term(term).page(1).to_a
    end
  end
end
