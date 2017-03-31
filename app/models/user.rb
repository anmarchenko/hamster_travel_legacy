# frozen_string_literal: true

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
#  locale                 :string
#  image_uid              :string
#  created_at             :datetime
#  updated_at             :datetime
#  currency               :string
#  home_town_id           :integer
#

class User < ApplicationRecord
  extend Dragonfly::Model
  extend Dragonfly::Model::Validations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authored_trips, class_name: 'Travels::Trip',
                            inverse_of: :author_user
  has_and_belongs_to_many :trips, class_name: 'Travels::Trip',
                                  inverse_of: :users, join_table: 'users_trips'

  has_many :cities, class_name: 'Geo::City', through: :trips
  has_and_belongs_to_many :manual_cities, class_name: 'Geo::City',
                                          inverse_of: nil,
                                          join_table: 'cities_users'

  has_many :outgoing_invites, class_name: 'Travels::TripInvite',
                              inverse_of: :inviting_user,
                              foreign_key: :inviting_user_id
  has_many :incoming_invites, class_name: 'Travels::TripInvite',
                              inverse_of: :invited_user,
                              foreign_key: :invited_user_id

  belongs_to :home_town, class_name: 'Geo::City', required: false

  # photo
  dragonfly_accessor :image
  def image_url
    image&.remote_url(host: Settings.media.cdn_host)
  end

  # User data
  validates_presence_of :last_name
  validates_presence_of :first_name
  validates_uniqueness_of :email, case_sensitive: false

  validates_size_of :image, maximum: 10.megabytes,
                            message: 'should be no more than 10 MB',
                            if: :image_changed?

  validates_property :format,
                     of: :image, in: %i(jpeg jpg png bmp),
                     case_sensitive: false,
                     message: 'should be either .jpeg, .jpg, .png, .bmp',
                     if: :image_changed?

  def home_town_text
    home_town.try(:translated_name, I18n.locale)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0].upcase}#{last_name[0].upcase}"
  end

  def background_color
    "userColor#{(id % 4)}"
  end

  def finished_trip_count
    trips.where(archived: false,
                status_code: Travels::Trip::StatusCodes::FINISHED).count
  end

  def visited_cities_ids
    # both cities from trips and manually added cities
    (cities.where('trips.archived' => false,
                  'trips.status_code' => Travels::Trip::StatusCodes::FINISHED)
           .pluck(:id) + manual_cities.pluck(:id)).uniq
  end

  def visited_cities_count
    visited_cities_ids.count
  end

  def visited_cities
    Geo::City.where(id: visited_cities_ids).with_translations
  end

  def visited_countries
    country_codes = visited_cities.map(&:country_code).uniq
    Geo::Country.where(country_code: country_codes).with_translations
  end

  def visited_countries_count
    Geo::City.where(id: visited_cities_ids).map(&:country_code).uniq.count
  end

  def as_json(**args)
    res = super(args.merge(except: ['email']))
    res['image_url'] = image_url
    res['full_name'] = full_name
    res['home_town_text'] = home_town_text
    res['color'] = background_color
    res['initials'] = initials
    # statistics
    res['finished_trips_count'] = finished_trip_count
    res['visited_cities_count'] = visited_cities_count
    res['visited_countries_count'] = visited_countries_count
    res
  end

  def self.find_by_term(term)
    return [] if term.blank?

    parts = term.split(/\s+/)
    return [] if parts.blank?

    if parts.count == 1
      query = 'first_name ILIKE ? OR last_name ILIKE ?'
      terms = ["#{parts.first}%", "#{parts.first}%"]
    else
      query = 'first_name ILIKE ? AND last_name ILIKE ?'
      terms = ["#{parts[0]}%", "#{parts[1]}%"]
    end

    where([query, terms].flatten).order(last_name: :asc)
  end
end
