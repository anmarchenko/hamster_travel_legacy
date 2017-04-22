# frozen_string_literal: true

module Views
  module FlagView
    def self.index_flags_with_titles(countries, flag_size = 16)
      countries.map { |country| flag_with_title(country, flag_size) }
    end

    def self.flag_with_title(country, size = 16)
      return '' if country.blank?
      <<-HTML.html_safe
        <img
          src='#{flag_url(country.country_code, size)}'
          class='flag flag-#{size}'
          width=#{size}
          height=#{size}
          title="#{country.name}"
        />
      HTML
    end

    def self.flag(country_code, size = 16)
      return '' if country_code.blank?
      <<-HTML.html_safe
        <img
          src='#{flag_url(country_code, size)}'
          class='flag flag-#{size}'
          width=#{size}
          height=#{size}
        />
      HTML
    end

    def self.flag_url(country_code, size)
      ApplicationController.helpers.image_url(
        "flags/#{size}/#{country_code.downcase}.png"
      )
    end
  end
end
