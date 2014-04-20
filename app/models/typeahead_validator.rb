
class TypeaheadValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    text_attribute = attribute
    code_attribute = text_attribute.to_s.gsub('_text', '_code')

    text_value = value
    code_value = record[code_attribute]

    if !text_value.blank? and code_value.blank?
      record.errors[text_attribute] << I18n.t('errors.from_list')
    end
  end

end

