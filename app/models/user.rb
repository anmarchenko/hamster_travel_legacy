# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  first_name             :string
#  last_name              :string
#  home_town_code         :string
#  home_town_text         :string
#  locale                 :string
#  image_uid              :string
#  mongo_id               :string
#  created_at             :datetime
#  updated_at             :datetime
#  currency               :string
#

class User < ActiveRecord::Base

  extend Dragonfly::Model
  extend Dragonfly::Model::Validations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authored_trips, class_name: 'Travels::Trip', inverse_of: :author_user
  has_and_belongs_to_many :trips, class_name: 'Travels::Trip', inverse_of: :users, join_table: 'users_trips'

  has_many :outgoing_invites, class_name: 'Travels::TripInvite', inverse_of: :inviting_user, foreign_key: :inviting_user_id
  has_many :incoming_invites, class_name: 'Travels::TripInvite', inverse_of: :invited_user, foreign_key: :invited_user_id

  belongs_to :home_town, class_name: 'Geo::City', required: false

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

  def home_town
    Geo::City.where(geonames_code: home_town_code).first
  end

  def self.find_by_term term
    return [] if term.blank?

    parts = term.split(/\s+/)
    return [] if parts.blank?

    if parts.count == 1
      query = "first_name ILIKE ? OR last_name ILIKE ?"
      terms = ["#{parts.first}%", "#{parts.first}%"]
    else
      query = "first_name ILIKE ? AND last_name ILIKE ?"
      terms = ["#{parts[0]}%", "#{parts[1]}%"]
    end

    where([query, terms].flatten).order(last_name: :asc)
  end

end
