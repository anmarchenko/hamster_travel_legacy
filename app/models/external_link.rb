# frozen_string_literal: true

# == Schema Information
#
# Table name: external_links
#
#  id            :integer          not null, primary key
#  description   :string
#  url           :text
#  linkable_id   :integer
#  linkable_type :string
#

require 'uri'

class ExternalLink < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  def description
    # refactor this
    return '' if url.blank?
    if !url.start_with?('http://') && !url.start_with?('https://')
      self.url = "http://#{url}"
    end
    parsed_uri = begin
                   URI.parse(url)
                 rescue StandardError
                   nil
                 end
    (parsed_uri.try(:host) || '').gsub('www.', '').capitalize
  end
end
