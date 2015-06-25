module ApplicationHelper
  TAB_PLAN = 'plan'
  TAB_REPORT = 'report'

  def currency_symbol
    currency = current_user.try(:currency) || CurrencyHelper::DEFAULT_CURRENCY
    currency = Money::Currency.find(currency)
    symbol = currency.try(:html_entity)
    symbol = currency.try(:symbol) if symbol.blank?
    symbol
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
        'datepicker-options' =>"{'starting-day': 1}",
        'current-text' => I18n.t('common.today'),
        'toggle-weeks-text' => I18n.t('common.toggle_weeks'),
        'clear-text' => I18n.t('common.clear'),
        'close-text' => I18n.t('common.datepicker_close') }
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

end
