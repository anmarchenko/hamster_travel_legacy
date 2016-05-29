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

class ExternalLink < ActiveRecord::Base

  belongs_to :linkable, polymorphic: true

  def description
    return '' if self.url.blank?
    if !self.url.start_with?('http://') && !self.url.start_with?('https://')
      self.url = "http://#{self.url}"
    end
    parsed_uri = URI.parse( self.url ) rescue nil
    (parsed_uri.try(:host) || '').gsub('www.', '').capitalize
  end

  def serializable_hash(_args)
    json = super(except: [:linkable_id, :linkable_type, :mongo_id])
    json['id'] = id.to_s
    json
  end

end
