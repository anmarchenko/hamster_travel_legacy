class ExternalLink

  include Mongoid::Document

  field :description
  field :url

  def as_json(*args)
    {
        id: id.to_s,
        description: description,
        url: url
    }
  end

end