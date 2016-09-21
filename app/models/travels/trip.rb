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

    module StatusCodes
      DRAFT = '0_draft'
      PLANNED = '1_planned'
      FINISHED = '2_finished'

      ALL = [DRAFT, PLANNED, FINISHED]
      OPTIONS = ALL.map { |type| ["common.#{type}", type] }
      TYPE_TO_TEXT = {
          DRAFT => "common.#{DRAFT}",
          PLANNED => "common.#{PLANNED}",
          FINISHED => "common.#{FINISHED}"
      }

      TYPE_TO_ICON = {
          DRAFT => 'draft',
          PLANNED => 'planned',
          FINISHED => 'finished'
      }
    end

    paginates_per 10

    has_and_belongs_to_many :users, class_name: 'User', inverse_of: :trips, join_table: 'users_trips'
    belongs_to :author_user, class_name: 'User', inverse_of: :authored_trips

    has_many :days, class_name: 'Travels::Day'
    has_many :caterings, class_name: 'Travels::Catering'
    has_many :pending_invites, class_name: 'Travels::TripInvite', inverse_of: :trip
    has_many :documents, class_name: 'Travels::Document'

    has_many :invited_users, class_name: 'User', through: :pending_invites
    has_many :places, class_name: 'Travels::Place', through: :days
    has_many :cities, class_name: 'Geo::City', through: :places

    def visited_cities
      cities.uniq
    end

    def visited_countries_codes
      visited_cities.map { |city| city.country_code }.uniq || []
    end

    dragonfly_accessor :image

    def image_url_or_default
      self.image.try(:remote_url) || ActionController::Base.helpers.image_url("plan/camera.svg")
    end

    def status_text
      I18n.t(StatusCodes::TYPE_TO_TEXT[status_code])
    end

    validates_presence_of :name, :author_user_id

    validates_presence_of :start_date, :end_date, if: :should_have_dates?
    validates_presence_of :planned_days_count, if: :without_dates?

    validates_numericality_of :planned_days_count, greater_than: 0, less_than: 31, if: :without_dates?

    validates :start_date, date: {before_or_equal_to: :end_date, message: I18n.t('errors.date_before')}, if: :should_have_dates?
    validates :end_date, date: {before: Proc.new { |record| record.start_date + 30.days },
                                message: I18n.t('errors.end_date_days', period: 30)}, if: :should_have_dates?

    validates_size_of :image, maximum: 10.megabytes, message: "should be no more than 10 MB", if: :image_changed?

    validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false,
                       message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?

    default_scope -> { where(:archived => false) }

    before_save :set_model_state
    after_create :update_plan!

    def set_model_state
      if self.dates_unknown
        self.start_date = nil
        self.end_date = nil
      else
        self.planned_days_count = nil
      end
    end

    def update_plan!
      self.days ||= []

      # ensure order
      ensure_days_order

      # push new days
      (self.days_count - self.days.length).times do
        push_new_day
      end

      # delete not needed days
      delete_last_days
    end

    def update_caterings!
      if caterings.present? && caterings.count == 1
        catering = caterings.first
        catering.update_attributes(days_count: self.days_count)
      end
    end

    def include_user(user)
      self.users.include?(user)
    end

    # private tasks can't be seen or cloned by user not participating in trip
    def can_be_seen_by? user
      !self.private || self.include_user(user)
    end

    def author
      author_user
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

    def name_for_file
      name[0, 50].gsub(/[^0-9A-zА-Яа-яёЁ.\-]/, '_')
    end

    def last_non_empty_day_index
      result = -1
      (days || []).each_with_index { |day, index| result = index unless day.is_empty? }
      return result
    end

    def budget_sum currency = CurrencyHelper::DEFAULT_CURRENCY
      Calculators::Budget.new(self, currency).sum
    end

    def transfers_hotel_budget currency = CurrencyHelper::DEFAULT_CURRENCY
      Calculators::Budget.new(self, currency).transfers_hotel
    end

    def activities_other_budget currency = CurrencyHelper::DEFAULT_CURRENCY
      Calculators::Budget.new(self, currency).activities_other
    end

    def catering_budget currency = CurrencyHelper::DEFAULT_CURRENCY
      Calculators::Budget.new(self, currency).catering
    end

    def caterings_data
      caterings.blank? ? create_caterings : caterings
    end

    def create_caterings
      [
          Travels::Catering.new(
              id: Time.now.to_i,
              persons_count: self.budget_for,
              days_count: self.days_count,
              amount_currency: self.currency,
              name: "#{self.name} (#{I18n.t('trips.show.catering')})"
          )
      ]
    end

    def draft?
      self.status_code == StatusCodes::DRAFT
    end

    def plan?
      self.status_code == StatusCodes::PLANNED
    end

    def report?
      self.status_code == StatusCodes::FINISHED
    end

    def without_dates?
      self.dates_unknown && self.draft?
    end

    def should_have_dates?
      !self.without_dates?
    end

    def as_json(**args)
      attrs = {}
      ['id', 'comment', 'start_date', 'end_date', 'name', 'short_description',
       'archived', 'private', 'budget_for'].each do |field|
        attrs[field] = self.send(field)
      end
      attrs['id'] = attrs['id'].to_s
      attrs
    end

    def short_json(flag_size = 16)
      res = {}
      ['id', 'name', 'start_date'].each do |field|
        res[field] = self.send(field)
      end
      res['countries'] = visited_countries_codes.map {
          |country_code| ApplicationController.helpers.flag(country_code, flag_size)
      }
      res['image_url'] = image_url_or_default
      res
    end

    def ensure_days_order days_to_order = nil
      (days_to_order || self.days).each_with_index do |day, index|
        if without_dates?
          day.date_when = nil
        else
          day.date_when = (self.start_date + index.days)
          # set dates of all transfers
          day.transfers.each { |transfer| transfer.set_date!(day.date_when) }
        end
        day.index = index
        day.save
      end
    end

    def report
      self.comment
    end

    def regenerate_countries_search_index!
      self.countries_search_index = visited_cities.map do |city|
        country = city.country
        "#{country.translated_name(:en)} #{country.translated_name(:ru)}"
      end.join(' ')
      self.save(validate: false)
    end

    private

    def push_new_day
      index = self.days.last.try(:index) || -1
      date = nil
      if should_have_dates?
        date = self.days.last.try(:date_when)
        if date.blank?
          date = self.start_date
        else
          date = date + 1.day
        end
      end
      self.days.create(date_when: date, index: index + 1)
    end

    def delete_last_days
      (self.days[days_count..-1] || []).each { |day| day.destroy }
    end

  end
end
