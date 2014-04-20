module Travels
  class Trip

    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :short_description, type: String

    field :start_date, type: Date
    field :end_date, type: Date

    field :published, type: Boolean, default: false

    has_many :trip_days, class_name: 'Travels::TripDay'

    has_and_belongs_to_many :users

    validates_presence_of :name, :start_date, :end_date
    validates :start_date, date: { before: :end_date, message: I18n.t('errors.date_before')  }
    validates_length_of :users, minimum: 1

    def include_user(user)
      users.include?(user)
    end

  end
end