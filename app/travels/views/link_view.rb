# frozen_string_literal: true

module Views
  module LinkView
    def self.index_json(links)
      links.map { |link| show_json(link) }
    end

    def self.show_json(link)
      link.as_json(except: %i[linkable_id linkable_type])
          .merge(
            'id' => link.id.to_s
          )
    end
  end
end
