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

    embeds_one :plan, class_name: 'Travels::Plan'

    field :author_user_id
    has_and_belongs_to_many :users, inverse_of: nil

    validates_presence_of :name, :start_date, :end_date, :author_user_id

    validates :start_date, date: { before: :end_date, message: I18n.t('errors.date_before')  }
    validates :end_date, date: {before: Proc.new {|record| record.start_date + 30.days}, message: I18n.t('errors.end_date_days', period: 30) }

    default_scope ->{order_by(created_at: -1)}

    def include_user(user)
      users.include?(user)
    end

    def author
      @author ||= User.where(id: author_user_id).first
    end

  end
end