module Travels
  class Trip

    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :short_description, type: String

    field :start_date, type: Date
    field :end_date, type: Date

    field :published, type: Boolean, default: false

    embeds_many :trip_days, class_name: 'Travels::TripDay'

    validates :name, presence: true
    validates :start_date, date: { before: :end_date }

  end
end