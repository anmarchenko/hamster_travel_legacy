class ExternalLink

  include Mongoid::Document

  field :description
  field :url

  def as_json(*args)
    json = super(except: [:_id])
    json['id'] = id.to_s
    json
  end

end