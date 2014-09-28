class User
  include Mongoid::Document
  include Mongoid::Timestamps

  extend Dragonfly::Model
  extend Dragonfly::Model::Validations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  # Additional core fields
  field :first_name, type: String
  field :last_name, type: String

  # User settings

  # home town
  # geonames_code
  field :home_town_code, type: String
  # localized text
  field :home_town_text, type: String

  field :locale, type: String

  has_many :authored_trips, class_name: 'Travels::Trip', inverse_of: :author_user

  # photo
  field :image_uid
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

  def trips
    Travels::Trip.where('user_ids' => id.to_s)
  end

  def home_town
    Geo::City.where(geonames_code: home_town_code).first
  end

  # PERSPECTIVE
  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
end