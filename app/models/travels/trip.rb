# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                     :integer          not null, primary key
#  name                   :string
#  short_description      :text
#  start_date             :date
#  end_date               :date
#  archived               :boolean          default(FALSE)
#  comment                :text
#  budget_for             :integer          default(1)
#  private                :boolean          default(FALSE)
#  image_uid              :string
#  status_code            :string           default("0_draft")
#  author_user_id         :integer
#  updated_at             :datetime
#  created_at             :datetime
#  currency               :string
#  dates_unknown          :boolean          default(FALSE)
#  planned_days_count     :integer
#  countries_search_index :string
#

module Travels
  class Trip < ApplicationRecord
    extend Dragonfly::Model
    extend Dragonfly::Model::Validations

    paginates_per 10

    has_and_belongs_to_many :users, class_name: 'User',
                                    inverse_of: :trips,
                                    join_table: 'users_trips'
    belongs_to :author_user, class_name: 'User', inverse_of: :authored_trips

    has_many :days, class_name: 'Travels::Day'
    has_many :caterings, class_name: 'Travels::Catering'
    has_many :pending_invites, class_name: 'Travels::TripInvite',
                               inverse_of: :trip
    has_many :documents, class_name: 'Travels::Document'

    has_many :invited_users, class_name: 'User', through: :pending_invites
    has_many :places, class_name: 'Travels::Place', through: :days
    has_many :cities, class_name: 'Geo::City', through: :places

    def visited_cities
      cities.uniq
    end

    # replace with countries relation
    def visited_countries_codes
      visited_cities.map(&:country_code).uniq || []
    end

    has_many :hotels, class_name: 'Travels::Hotel', through: :days
    has_many :transfers, class_name: 'Travels::Transfer', through: :days
    has_many :activities, class_name: 'Travels::Activity', through: :days
    has_many :expenses, class_name: 'Travels::Expense', through: :days

    dragonfly_accessor :image

    def image_url_or_default
      image&.remote_url(host: Settings.media.cdn_host) ||
        ActionController::Base.helpers.image_url('plan/camera.svg')
    end

    validates_presence_of :name, :author_user_id

    validates_presence_of :start_date, :end_date, if: :should_have_dates?
    validates_presence_of :planned_days_count, if: :without_dates?

    validates_numericality_of :planned_days_count, greater_than: 0,
                                                   less_than: 31,
                                                   if: :without_dates?

    validates :start_date, date: {
      before_or_equal_to: :end_date,
      message: I18n.t('errors.date_before')
    }, if: :should_have_dates?

    validates :end_date, date: {
      before: proc { |record| record.start_date + 30.days },
      message: I18n.t('errors.end_date_days', period: 30)
    }, if: :should_have_dates?

    validates_size_of :image, maximum: 10.megabytes,
                              message: 'should be no more than 10 MB',
                              if: :image_changed?

    validates_property :format,
                       of: :image,
                       in: %i[jpeg jpg png bmp],
                       case_sensitive: false,
                       message: 'should be either .jpeg, .jpg, .png, .bmp',
                       if: :image_changed?

    default_scope(-> { where(archived: false) })

    before_save(-> { Trips.nullify_dates(self) })
    after_create(-> { Trips::Days.on_trip_update(self) })

    def include_user(user)
      users.include?(user)
    end

    # private tasks can't be seen or cloned by user not participating in trip
    def can_be_seen_by?(user)
      !private || include_user(user)
    end

    def days_count
      return planned_days_count if without_dates?
      return nil if start_date.blank? || end_date.blank?
      (end_date - start_date + 1).to_i
    end

    def period
      return 0 unless days_count
      days_count - 1
    end

    def draft?
      status_code == Trips::StatusCodes::DRAFT
    end

    def plan?
      status_code == Trips::StatusCodes::PLANNED
    end

    def report?
      status_code == Trips::StatusCodes::FINISHED
    end

    def without_dates?
      dates_unknown && (draft? || plan?)
    end

    def should_have_dates?
      !without_dates?
    end

    def as_json(**args)
      super.merge('id' => id.to_s)
    end
  end
end
