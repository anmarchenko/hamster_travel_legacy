# frozen_string_literal: true
module Updaters
  class Entity
    def delete_nested(collection, params)
      to_delete = []
      collection.each do |item|
        delete = params.count { |v| v[:id].to_s == item.id.to_s }.zero?
        to_delete << item.id if delete
      end
      collection.where(id: to_delete).destroy_all
    end

    def process_nested(collection, params, nested_list = [])
      delete_nested collection, params
      params.each do |item_hash|
        item_id = begin
                    (item_hash.delete(:id).to_i % 2_147_483_647)
                  rescue
                    nil
                  end
        item = collection.where(id: item_id).first unless item_id.nil?

        nested_hash = {}
        nested_list.each do |nested_attr|
          nested_hash[nested_attr] = item_hash.delete(nested_attr)
        end

        process_amount(item_hash)
        if item.blank?
          item = collection.create(item_hash)
        else
          item.update_attributes(item_hash)
        end

        nested_hash.each do |attr, values|
          process_nested(item.send(attr), values) if values.present?
        end
      end
    end

    def process_ordered(params)
      params.each_with_index do |item_hash, index|
        item_hash['order_index'] = index
      end
    end

    def process_amount(item_hash)
      return if item_hash['amount_cents'].nil?
      (item_hash['amount_cents'] = begin
                                     item_hash['amount_cents'].to_i
                                   rescue
                                     nil
                                   end)
    end
  end
end
