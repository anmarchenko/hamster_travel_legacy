class User < ActiveRecord::Base

  extend Dragonfly::Model
  extend Dragonfly::Model::Validations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # TODO fix it
  def authored_trips
    #, class_name: 'Travels::Trip', inverse_of: :author_user
    Travels::Trip.where(author_user_id: self.mongo_id)
  end

  # photo
  dragonfly_accessor :image
  def image_url_or_default
    self.image.try(:remote_url) || 'https://s3.amazonaws.com/altmer-cdn/images/profile.jpeg'
  end

  # User data
  validates_presence_of :last_name
  validates_presence_of :first_name
  validates_uniqueness_of :email, :case_sensitive => false
  validates :home_town_text, typeahead: true

  validates_size_of :image, maximum: 10.megabytes, message: "should be no more than 10 MB", if: :image_changed?

  validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false,
                     message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?

  def full_name
    '%s %s' % [first_name, last_name]
  end

  # TODO fix it
  def trips
    Travels::Trip.where('user_ids' => mongo_id.to_s)
  end

  def home_town
    Geo::City.where(geonames_code: home_town_code).first
  end

end