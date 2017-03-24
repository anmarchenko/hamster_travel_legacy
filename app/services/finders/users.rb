# frozen_string_literal: true

module Finders
  module Users
    module_function

    def search(term, current_user)
      return [] if term.blank? || term.length < 2

      query = User.find_by_term(term).page(1)
      query = query.where.not(id: current_user.id) if current_user.present?
      query.collect do |user|
        {
          name: user.full_name, text: user.full_name, code: user.id.to_s,
          photo_url: user.image_url, color: user.background_color,
          initials: user.initials
        }
      end
    end
  end
end
