# frozen_string_literal: true

module Users
  def self.search(term, current_user)
    return [] if term.blank? || term.length < 2
    User.find_by_term(term)
        .excluding_user(current_user)
        .page(1)
  end
end
