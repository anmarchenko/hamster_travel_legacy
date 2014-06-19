module Travels
  class Trip

    include Mongoid::Document
    include Mongoid::Timestamps

    paginates_per 9

    field :name, type: String
    field :short_description, type: String

    field :start_date, type: Date
    field :end_date, type: Date

    field :published, type: Boolean, default: false

    field :author_user_id
    has_and_belongs_to_many :users, inverse_of: nil

    embeds_many :days, class_name: 'Travels::Day'

    validates_presence_of :name, :start_date, :end_date, :author_user_id

    validates :start_date, date: { before: :end_date, message: I18n.t('errors.date_before')  }
    validates :end_date, date: {before: Proc.new {|record| record.start_date + 30.days},
                                message: I18n.t('errors.end_date_days', period: 30) }

    default_scope ->{order_by(created_at: -1)}

    after_save :update_plan

    def update_plan
      self.days ||= []
      days_count = (self.end_date - self.start_date).to_i + 1
      (self.days[days_count..-1] || []).each { |day| day.destroy }
      self.days.each_with_index do |day, index|
        day.date_when = (self.start_date + index.days)
        day.save
      end
      (days_count - self.days.length).times do
        date = self.days.last.try(:date_when)
        if date.blank?
          date = self.start_date
        else
          date = date + 1.day
        end
        self.days.create(trip: self, date_when: date)
      end
    end

    def include_user(user)
      users.include?(user)
    end

    def author
      @author ||= User.where(id: author_user_id).first
    end

    def last_non_empty_day_index
      result = -1
      (days || []).each_with_index { |day, index| result = index unless day.is_empty? }
      return result
    end

  end
end