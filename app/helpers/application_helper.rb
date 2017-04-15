# frozen_string_literal: true

module ApplicationHelper
  def currency_symbol(currency = nil)
    currency ||= current_user&.currency
    currency ||= CurrencyHelper::DEFAULT_CURRENCY
    currency = Money::Currency.find(currency)
    currency.try(:symbol)
  end

  def default_currency_hash(trip, user)
    "amount_currency_text: '#{default_currency_text_for_trip(trip, user)}'," \
    " amount_currency: '#{default_currency_for_trip(trip, user)}'"
  end

  def default_currency_for_trip(trip, user)
    trip.currency || user.try(:currency) || CurrencyHelper::DEFAULT_CURRENCY
  end

  def default_currency_text_for_trip(trip, user)
    Money::Currency.find(default_currency_for_trip(trip, user))&.symbol
  end

  # rubocop:disable MethodLength
  def datepicker_options(model_name, record = nil)
    res = {
      'ng-model' => model_name, 'data-provide' => 'datepicker',
      'data-placement' => 'bottom', 'data-date-format' => 'dd.mm.yyyy',
      'data-date-week-start' => 1, 'data-date-autoclose' => true,
      'data-date-language' => I18n.locale, 'data-date-start-view' => 'day',
      'autocomplete' => 'off'
    }
    unless record.blank? || record.send(model_name).blank?
      res['ng-init'] = "#{model_name}='#{record.send(model_name)}'"
    end
    res
  end

  def trip_status_class(status_code)
    {
      Trips::StatusCodes::DRAFT => 'bg-draft',
      Trips::StatusCodes::PLANNED => 'bg-planned',
      Trips::StatusCodes::FINISHED => 'bg-finished'
    }[status_code]
  end

  def trip_period(trip, original_trip)
    if original_trip.blank?
      Trips.last_non_empty_day_index(trip)
    else
      original_trip.period
    end
  end

  def trip_status_options
    Trips::StatusCodes::OPTIONS.map do |option|
      [I18n.t(option[0]), option[1]]
    end
  end

  def transfer_type_options
    Travels::Transfer::Types::OPTIONS.map do |option|
      [I18n.t(option[0]), option[1]]
    end
  end

  def trip_start_date(trip)
    (l trip.start_date, format: :month).html_safe if trip.start_date.present?
  end

  def days_count(trip)
    "#{trip.days_count}&nbsp;" \
    "#{I18n.t('common.days', count: trip.days_count)}".html_safe
  end

  def dates_view(trip)
    if trip.start_date == trip.end_date
      trip.start_date.to_s
    else
      "#{trip.start_date} - #{trip.end_date}"
    end
  end

  def trip_dates(trip)
    if trip.start_date.present? && trip.end_date.present?
      "#{dates_view(trip)} (#{days_count(trip)})".html_safe
    else
      days_count(trip).html_safe
    end
  end
end
