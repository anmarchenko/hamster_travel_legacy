module ApplicationHelper
  TAB_PLAN = 'plan'
  TAB_REPORT = 'report'
  TAB_PLAN_ACTIVITIES = 'plan_activities'
  TAB_CATERING = 'catering'

  def currency_symbol currency = nil
    currency = (current_user.try(:currency) || CurrencyHelper::DEFAULT_CURRENCY) if currency.blank?
    currency = Money::Currency.find(currency)
    currency.try(:symbol)
  end

  def default_currency_hash trip, user
    "amount_currency_text: '#{default_currency_text_for_trip(trip, user)}', amount_currency: '#{default_currency_for_trip(trip, user)}'"
  end

  def default_currency_for_trip trip, user
    trip.currency || user.try(:currency) || CurrencyHelper::DEFAULT_CURRENCY
  end

  def default_currency_text_for_trip trip, user
    currency = default_currency_for_trip(trip, user)
    currency = Money::Currency.find(currency)
    currency.try(:symbol)
  end

  def exchange_money from, to, amount
    Money.new(amount * 100, from).exchange_to(to)
  end

  def error_messages! (object)
    return '' if object.errors.empty?

    messages = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved')

    html = <<-HTML
    <div class="alert alert-danger">
      <button class='close' data-dismiss='alert'>&times;</button>
      <h4>#{sentence}</h4>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def datepicker_options(model_name, record = nil)
    res = {'datepicker-popup' => 'dd.MM.yyyy', 'ng-model' => model_name, 'show-weeks' => 'false',
           'datepicker-options' => "{'starting-day': 1}",
           'current-text' => I18n.t('common.today'),
           'toggle-weeks-text' => I18n.t('common.toggle_weeks'),
           'clear-text' => I18n.t('common.clear'),
           'close-text' => I18n.t('common.datepicker_close'),
           'is-open' => "datepicker_opened_#{model_name}",
           'ng-focus' => "datepicker_opened_#{model_name} = true"
    }
    res.merge!('ng-init' => "#{model_name}=#{record.send(model_name).strftime('%Q')}") unless record.blank? or
        record.send(model_name).blank?
    res
  end

  def trip_status_class status_code
    {
        Travels::Trip::StatusCodes::DRAFT => 'bg-draft',
        Travels::Trip::StatusCodes::PLANNED => 'bg-planned',
        Travels::Trip::StatusCodes::FINISHED => 'bg-finished'
    }[status_code]
  end

  def trip_period trip, original_trip
    original_trip.blank? ? trip.last_non_empty_day_index : original_trip.period
  end

  def trip_status_options
    Travels::Trip::StatusCodes::OPTIONS.map do |option|
      [I18n.t(option[0]), option[1]]
    end
  end

  def transfer_type_options
    Travels::Transfer::Types::OPTIONS.map do |option|
      [I18n.t(option[0]), option[1]]
    end
  end

  def trip_start_date trip
    (l trip.start_date, format: :month).html_safe if trip.start_date.present?
  end

end
