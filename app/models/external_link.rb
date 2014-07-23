require 'uri'

class ExternalLink

  include Mongoid::Document

  field :description
  def description
    return '' if self.url.blank?
    self.url = "http://#{self.url}" unless self.url.start_with? 'http://'
    parsed_uri = URI.parse( self.url ) rescue nil
    (parsed_uri.try(:host) || '').gsub('www.', '').capitalize
  end

  field :url

  def as_json(*args)
    json = super(except: [:_id])
    json['id'] = id.to_s
    json
  end

end