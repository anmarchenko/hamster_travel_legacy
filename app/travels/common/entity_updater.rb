# frozen_string_literal: true

module Common
  module EntityUpdater
    def save_nested(collection, params, nested = [])
      params ||= [] # if we get nil we treat it like empty array and delete all
      delete_nested collection, params
      params.each do |item_hash|
        item_hash = fix_amount(item_hash)
        item_id = extract_id(item_hash)
        item = collection.where(id: item_id).first unless item_id.nil?
        item = create_or_update(item_hash.except(*nested), collection, item)
        nested.each { |field| save_nested(item.send(field), item_hash[field]) }
      end
    end

    def order_params(params)
      params.each_with_index.map do |item_hash, index|
        item_hash.merge('order_index' => index)
      end
    end

    def fix_amount(hash)
      if hash.key?('amount_cents')
        hash.except('amount_cents', 'amount_currency').merge(
          'amount' => Amounts.from_frontend(
            hash['amount_cents'].to_i,
            hash['amount_currency']
          )
        )
      else
        hash
      end
    end

    def delete_nested(collection, params)
      to_delete = []
      collection.each do |item|
        delete = params.count { |v| v[:id].to_s == item.id.to_s }.zero?
        to_delete << item.id if delete
      end
      collection.where(id: to_delete).destroy_all
    end

    def create_or_update(item_hash, collection, item)
      if item.blank?
        collection.create(item_hash)
      else
        item.update_attributes(item_hash)
        item
      end
    end

    def extract_id(hash)
      id = hash.delete(:id).to_i
      id % 2_147_483_647 if id.present?
    end
  end
end
