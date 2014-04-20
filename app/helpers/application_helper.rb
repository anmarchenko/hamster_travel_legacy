module ApplicationHelper

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
        'close-text' => I18n.t('common.datepicker_close')}
    res.merge!('ng-init' => "#{model_name}='#{record.send(model_name)}';") unless record.blank? or record.send(model_name).blank?
    res
  end

end
