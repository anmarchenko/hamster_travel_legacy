# frozen_string_literal: true

module Views
  module UserView
    def self.index_json(users)
      users.map { |user| show_for_list_json(user) }
    end

    def self.show_for_list_json(user)
      {
        name: user.full_name, text: user.full_name, code: user.id.to_s,
        photo_url: user.image_url, color: user.background_color,
        initials: user.initials
      }
    end
  end
end
